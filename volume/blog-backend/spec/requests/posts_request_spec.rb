require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let!(:title1) { Faker::Books::CultureSeries.book }
  let!(:title2) { Faker::Books::CultureSeries.book }

  let!(:registred_post1) { create(:post, :with_registred_user) }
  let!(:registred_headers1) { header_for_user(registred_post1.user) }

  let!(:registred_post2) { create(:post, :with_registred_user) }
  let!(:registred_headers2) { header_for_user(registred_post2.user) }

  let!(:admin_post1) { create(:post, :with_admin_user) }
  let!(:admin_headers1) { header_for_user(admin_post1.user) }

  let!(:admin_post2) { create(:post, :with_admin_user) }
  let!(:admin_blog_user2) { admin_post2.user }
  let!(:admin_headers2) { header_for_user(admin_blog_user2) }

  describe '#created' do
    context 'when registred user' do
      context 'and is blog owner' do
        context 'and data is valid' do
          before { post "/blogs/#{registred_post1.blog.id}/posts", params: { title: title1 }, headers: registred_headers1 }

          it { expect(response).to have_http_status(:created) }

          it 'contains fields from params' do
            expect(json_response['title']).to eq(title1)
            expect(json_response['blog_id']).to eq(registred_post1.blog.id)
            expect(json_response['user_id']).to eq(registred_post1.user.id)
          end
        end

        context 'and data is invalid' do
          before { post "/blogs/#{registred_post1.blog.id}/posts", params: { title: '' }, headers: registred_headers1 }

          it { expect(response).to have_http_status(:unprocessable_entity) }

          it 'contains empty title error message' do
            expect(json_response_error).to eq("Validation failed: Title can't be blank")
          end
        end
      end

      context 'and is not blog owner' do
        before { post "/blogs/#{registred_post1.blog.id}/posts", params: { title: title2 }, headers: registred_headers2 }

        it { expect(response).to have_http_status(:unauthorized) }
      end
    end

    context 'when admin user' do
      context 'and is blog owner' do
        before { post "/blogs/#{admin_post1.blog.id}/posts", params: { title: title1 }, headers: admin_headers1 }

        it { expect(response).to have_http_status(:created) }

        it 'contains fields from params' do
          expect(json_response['title']).to eq(title1)
          expect(json_response['blog_id']).to eq(admin_post1.blog.id)
          expect(json_response['user_id']).to eq(admin_post1.user.id)
        end
      end

      context 'and is not blog owner' do
        before { post "/blogs/#{admin_post2.blog.id}/posts", params: { title: title2 }, headers: admin_headers1 }

        it { expect(response).to have_http_status(:unauthorized) }
      end
    end
  end

  describe '#destroy' do
    context 'when blog does not exist' do
      before { delete "/blogs/#{admin_post1.user.id}/posts/-1", headers: admin_headers1 }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when user is registred' do
      context 'it destroys' do
        context 'when post belongs to himself' do
          before { delete "/blogs/#{registred_post1.blog.id}/posts/#{registred_post1.id}", headers: registred_headers1 }

          it { expect(response).to have_http_status(:no_content) }
        end
      end

      context 'it does NOT destroys' do
        context 'when post belongs other registred user' do
          before { delete "/blogs/#{registred_post2.blog.id}/posts/#{registred_post2.id}", headers: registred_headers1 }

          it { expect(response).to have_http_status(:unauthorized) }
        end

        context 'when post belongs other admin user' do
          before { delete "/blogs/#{admin_post1.blog.id}/posts/#{admin_post1.id}", headers: registred_headers1 }

          it { expect(response).to have_http_status(:unauthorized) }
        end
      end
    end

    context 'when user is admin' do
      context 'it destroys' do
        context 'when post belongs to himself' do
          before { delete "/blogs/#{admin_post1.blog.id}/posts/#{admin_post1.id}", headers: admin_headers1 }

          it { expect(response).to have_http_status(:no_content) }
        end

        context 'when post belongs to registred user' do
          before { delete "/blogs/#{registred_post1.blog.id}/posts/#{registred_post1.id}", headers: admin_headers1 }

          it { expect(response).to have_http_status(:no_content) }
        end
      end

      context 'it does NOT destroys' do
        context 'when post belongs other admin user' do
          before { delete "/blogs/#{admin_post2.blog.id}/posts/#{admin_post2.id}", headers: admin_headers1 }

          it { expect(response).to have_http_status(:unauthorized) }
        end
      end
    end
  end

  describe '#show' do
    context 'when user is non-registered' do
      context 'and blog is public' do
        let!(:public_blog) { create(:blog, :public) }
        let!(:public_user) { public_blog.user }
        let!(:public_post) { create(:post, blog: public_blog, user: public_user) }

        before { get "/blogs/#{public_blog.id}/posts/#{public_post.id}" }

        it { expect(response).to have_http_status(:ok) }
      end

      context 'and blog is private' do
        let!(:private_blog) { create(:blog, :private) }
        let!(:private_user) { private_blog.user }
        let!(:private_post) { create(:post, blog: private_blog, user: private_user) }

        before { get "/blogs/#{private_blog.id}/posts/#{private_post.id}" }

        it { expect(response).to have_http_status(:unauthorized) }
      end
    end

    context 'when user is registered' do
      context 'and blog belongs to himself' do
        before { get "/blogs/#{registred_post1.blog.id}/posts/#{registred_post1.id}", headers: registred_headers1 }

        it { expect(response).to have_http_status(:ok) }
      end

      context 'and blog belongs to another user' do
        before { get "/blogs/#{registred_post1.blog.id}/posts/#{registred_post1.id}", headers: registred_headers2 }

        it { expect(response).to have_http_status(:ok) }
      end
    end

    context 'when user is admin' do
      context 'and blog belongs to himself' do
        before { get "/blogs/#{admin_post1.blog.id}/posts/#{admin_post1.id}", headers: admin_headers1 }

        it { expect(response).to have_http_status(:ok) }
      end

      context 'and blog belongs to another user' do
        before { get "/blogs/#{registred_post1.blog.id}/posts/#{registred_post1.id}", headers: admin_headers1 }

        it { expect(response).to have_http_status(:ok) }
      end
    end
  end
end
