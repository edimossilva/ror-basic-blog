require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let!(:title1) { Faker::Books::CultureSeries.book }
  let!(:title2) { Faker::Books::CultureSeries.book }

  let!(:registred_post1) { create(:post, :with_registred_user) }
  let!(:registred_blog1) { registred_post1.blog }
  let!(:registred_blog_user1) { registred_blog1.user }
  let!(:registred_headers1) { header_for_user(registred_blog_user1) }

  let!(:registred_blog2) { create(:blog, :with_registred_user) }
  let!(:registred_blog_user2) { registred_blog2.user }
  let!(:registred_headers2) { header_for_user(registred_blog_user2) }

  let!(:admin_post1) { create(:post, :with_admin_user) }
  let!(:admin_blog1) { admin_post1.blog }
  let!(:admin_blog_user1) { admin_blog1.user }
  let!(:admin_headers1) { header_for_user(admin_blog_user1) }

  let!(:admin_post2) { create(:post, :with_admin_user) }
  let!(:admin_blog2) { admin_post2.blog }
  let!(:admin_blog_user2) { admin_blog2.user }
  let!(:admin_headers2) { header_for_user(admin_blog_user2) }

  describe '#created' do
    context '2.ii - when registred user' do
      context 'and is blog owner' do
        context 'and data is valid' do
          before do
            post "/blogs/#{registred_blog1.id}/posts", params: { title: title1 }, headers: registred_headers1
          end

          it 'responds :created' do
            expect(response).to have_http_status(:created)
          end

          it 'contains fields from params' do
            json_response = JSON.parse(response.body)
            expect(json_response['title']).to eq(title1)
            expect(json_response['blog_id']).to eq(registred_blog1.id)
            expect(json_response['user_id']).to eq(registred_blog_user1.id)
          end
        end

        context 'and data is invalid' do
          before do
            post "/blogs/#{registred_blog1.id}/posts", params: { title: '' }, headers: registred_headers1
          end

          it 'responds :created' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'contains fields from params' do
            json_response = JSON.parse(response.body)
            expect(json_response['error_message']).to eq('Post not created')
          end
        end
      end

      context 'and is not blog owner' do
        before do
          post "/blogs/#{registred_blog1.id}/posts", params: { title: title2 }, headers: registred_headers2
        end

        it 'responds :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context '3.i - when admin user' do
      context 'and is blog owner' do
        before do
          post "/blogs/#{admin_blog1.id}/posts", params: { title: title1 }, headers: admin_headers1
        end

        it 'responds :created' do
          expect(response).to have_http_status(:created)
        end

        it 'contains fields from params' do
          json_response = JSON.parse(response.body)
          expect(json_response['title']).to eq(title1)
          expect(json_response['blog_id']).to eq(admin_blog1.id)
          expect(json_response['user_id']).to eq(admin_blog1.user.id)
        end
      end

      context 'and is not blog owner' do
        before do
          post "/blogs/#{admin_blog2.id}/posts", params: { title: title2 }, headers: admin_headers1
        end

        it 'responds :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe '#destroy' do
    context 'when blog not found' do
      before do
        delete "/blogs/#{admin_post1.user.id}/posts/-1", headers: admin_headers1
      end

      it 'responds :not_found' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context '2.iii - when user is registred' do
      context 'it destroys' do
        context 'when post belongs to himself' do
          before do
            delete "/blogs/#{registred_post1.blog.id}/posts/#{registred_post1.id}", headers: registred_headers1
          end

          it 'responds :no_content' do
            expect(response).to have_http_status(:no_content)
          end
        end
      end

      context 'it does NOT destroys' do
        context 'when post belongs other user' do
          before do
            delete "/blogs/#{admin_post1.user.id}/posts/#{admin_post2.id}", headers: registred_headers1
          end

          it 'responds :not_found' do
            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end

    context '3.iii - when user is admin' do
      context 'it destroys' do
        context 'when post belongs to himself' do
          before do
            delete "/blogs/#{admin_post1.blog.id}/posts/#{admin_post1.id}", headers: admin_headers1
          end

          it 'responds :no_content' do
            expect(response).to have_http_status(:no_content)
          end
        end

        context 'when post belongs to registred user' do
          before do
            delete "/blogs/#{registred_post1.blog.id}/posts/#{registred_post1.id}", headers: admin_headers1
          end

          it 'responds :no_content' do
            expect(response).to have_http_status(:no_content)
          end
        end
      end

      context 'it does NOT destroys' do
        context 'when post belongs other admin user' do
          before do
            delete "/blogs/#{admin_post2.blog.id}/posts/#{admin_post2.id}", headers: admin_headers1
          end

          it 'responds :unauthorized' do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end
  end

  describe '#show' do
    context '1.i - when user is non-registered' do
      context 'and blog is public' do
        let!(:public_blog) { create(:blog, :public) }
        let!(:public_user) { public_blog.user }
        let!(:public_post) { create(:post, blog: public_blog, user: public_user) }

        before do
          get "/blogs/#{public_blog.id}/posts/#{public_post.id}"
        end

        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'and blog is private' do
        let!(:private_blog) { create(:blog, :private) }
        let!(:private_user) { private_blog.user }
        let!(:private_post) { create(:post, blog: private_blog, user: private_user) }

        before do
          get "/blogs/#{private_blog.id}/posts/#{private_post.id}"
        end

        it 'responds :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when user is registered' do
      context 'and blog belongs to himself' do
        before do
          get "/blogs/#{registred_blog1.id}/posts/#{registred_post1.id}", headers: registred_headers1
        end

        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'and blog belongs to another user' do
        before do
          get "/blogs/#{registred_blog1.id}/posts/#{registred_post1.id}", headers: registred_headers2
        end

        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'when user is admin' do
      context 'and blog belongs to himself' do
        before do
          get "/blogs/#{admin_post1.blog.id}/posts/#{admin_post1.id}", headers: admin_headers1
        end

        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'and blog belongs to another user' do
        before do
          get "/blogs/#{registred_blog1.id}/posts/#{registred_post1.id}", headers: admin_headers1
        end

        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
