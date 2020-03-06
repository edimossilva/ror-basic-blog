require 'rails_helper'

RSpec.describe 'Blogs', type: :request do
  let!(:name) { Faker::Name.name }
  let!(:is_private) { Faker::Boolean.boolean }

  let!(:registred_user) { create(:user, :registred) }
  let!(:registred_headers) { header_for_user(registred_user) }

  let!(:registred_user_blog) { create(:blog, :with_registred_user) }
  let!(:registred_user_headers) { header_for_user(registred_user_blog.user) }

  let!(:admin_user_blog) { create(:blog, :with_admin_user) }
  let!(:admin_headers) { header_for_user(admin_user_blog.user) }

  let!(:another_admin_user) { create(:user, :admin) }
  let!(:another_admin_headers) { header_for_user(another_admin_user) }

  let!(:invalid_headers) { header_for_user(User.new) }

  describe '#create' do
    context 'When receive valida data' do
      context 'when registred user' do
        before do
          post '/blogs', params: { name: name, is_private: is_private, user_id: registred_user.id }, headers: registred_headers
        end

        it 'responds :created' do
          expect(response).to have_http_status(:created)
        end

        it 'contains fields from params' do
          json_response = JSON.parse(response.body)
          expect(json_response['name']).to eq(name)
          expect(json_response['is_private']).to eq(is_private)
        end
      end
    end

    context 'When receive invalida data' do
      context 'when token is invalid' do
        context 'when token has invalid decode' do
          before do
            post '/blogs', params: { name: name, is_private: is_private, user_id: registred_user.id }, headers: invalid_headers
          end
          it 'responds :unauthorized' do
            expect(response).to have_http_status(:unauthorized)
          end
        end

        context 'when user is not valid' do
          before do
            post '/blogs', params: { name: name, is_private: is_private, user_id: registred_user.id }, headers: invalid_headers
          end
          it 'responds :unauthorized' do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
      context 'when registred user' do
        context 'when blog data is invalid' do
          context 'when name is empty' do
            before do
              post '/blogs', params: { name: '', is_private: is_private, user_id: registred_user.id }, headers: registred_headers
            end

            it 'responds :unprocessable_entity' do
              expect(response).to have_http_status(:unprocessable_entity)
            end

            it 'contains error messages' do
              json_response = JSON.parse(response.body)
              expect(json_response['error_message']).to eq("Validation failed: Name can't be blank")
            end

            it 'error is name: cant be empty' do
              json_response = JSON.parse(response.body)
              expect(json_response['error_message']).to eq("Validation failed: Name can't be blank")
            end
          end
          context 'when user_id is empty' do
            before do
              post '/blogs', params: { name: name, is_private: is_private, user_id: '' }, headers: registred_headers
            end

            it 'responds :unprocessable_entity' do
              expect(response).to have_http_status(:unprocessable_entity)
            end

            it 'contains error messages' do
              json_response = JSON.parse(response.body)
              expect(json_response['error_message']).to eq('Validation failed: User must exist')
            end

            it 'error is name: cant be empty' do
              json_response = JSON.parse(response.body)
              expect(json_response['error_message']).to eq('Validation failed: User must exist')
            end
          end
        end
      end
    end
  end

  describe '#destroy' do
    context 'when blog not found' do
      before do
        delete '/blogs/-1', headers: admin_headers
      end

      it 'responds :not_found' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context '3.ii - when user is admin' do
      context 'it destroys' do
        context 'when blog belongs to himself' do
          before do
            delete "/blogs/#{admin_user_blog.id}", headers: admin_headers
          end

          it 'responds :no_content' do
            expect(response).to have_http_status(:no_content)
          end
        end

        context 'when blog belongs to registred user' do
          before do
            delete "/blogs/#{registred_user_blog.id}", headers: admin_headers
          end

          it 'responds :no_content' do
            expect(response).to have_http_status(:no_content)
          end
        end
      end
      context 'it does not destroys' do
        context 'when blog belongs to another admin' do
          before do
            delete "/blogs/#{admin_user_blog.id}", headers: another_admin_headers
          end

          it 'responds :unauthorized' do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end

    context 'when user is not admin' do
      before do
        delete "/blogs/#{registred_user_blog.id}", headers: registred_user_headers
      end

      it 'responds :unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe '#list' do
    let!(:public_blogs) { create_list(:blog, 10, :public) }
    let!(:private_blogs) { create_list(:blog, 2, :public) }

    let!(:public_blogs_count) { Blog.where(is_private: false).count }
    let!(:all_blogs_count) { Blog.all.count }

    context 'when user is non-registred' do
      before do
        get '/blogs'
      end

      it 'responds :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'return publics blogs' do
        json_response = JSON.parse(response.body)['data']
        expect(json_response.count).to eq(public_blogs_count)
      end
    end

    context 'when user is registred' do
      before do
        get '/blogs', headers: registred_headers
      end

      it 'responds :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'return all blogs' do
        json_response = JSON.parse(response.body)['data']
        expect(json_response.count).to eq(all_blogs_count)
      end
    end

    context 'when user is admin' do
      before do
        get '/blogs', headers: admin_headers
      end

      it 'responds :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'return all blogs' do
        json_response = JSON.parse(response.body)['data']
        expect(json_response.count).to eq(all_blogs_count)
      end
    end

    context 'when token is on ly Basic' do
      before do
        get '/blogs', headers: { Authorization: 'Basic' }
      end

      it 'responds :unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe '#show' do
    context '1.i - when user is non-registered' do
      context 'and blog is public' do
        let!(:public_blog) { create(:blog, :public) }

        before do
          get "/blogs/#{public_blog.id}"
        end

        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'and blog is private' do
        let!(:private_blog) { create(:blog, :private) }

        before do
          get "/blogs/#{private_blog.id}"
        end

        it 'responds :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context '2.iv - when user is registered' do
      context 'and blog is public' do
        let!(:public_blog) { create(:blog, :public) }

        before do
          get "/blogs/#{public_blog.id}", headers: registred_user_headers
        end

        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'and blog is private' do
        let!(:private_blog) { create(:blog, :private) }

        before do
          get "/blogs/#{private_blog.id}", headers: registred_user_headers
        end

        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context '3.i - when user is admin' do
      context 'and blog is public' do
        let!(:public_blog) { create(:blog, :public) }

        before do
          get "/blogs/#{public_blog.id}", headers: admin_headers
        end

        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'and blog is private' do
        let!(:private_blog) { create(:blog, :private) }

        before do
          get "/blogs/#{private_blog.id}", headers: admin_headers
        end

        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
