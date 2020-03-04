require 'rails_helper'

RSpec.describe "Posts", type: :request do

  let!(:title1) { Faker::Books::CultureSeries.book }
  let!(:title2) { Faker::Books::CultureSeries.book }
  describe '#created' do  
    context '2.ii - when registred user' do
      let!(:blog1) { create :blog }
      let!(:blog_registred_user1) { blog1.user }
    
      let!(:token1) { JsonWebToken.encode(user_id: blog_registred_user1.id) }
      
      let!(:headers1) { 
        { "Authorization" => token1 } 
      }
    
      let!(:blog2) { create :blog }
      let!(:blog_registred_user2) { blog2.user }
    
      let!(:token2) { JsonWebToken.encode(user_id: blog_registred_user2.id) }
      
      let!(:headers2) { 
        { "Authorization" => token2 } 
      }

      context "and is blog owner" do
        context 'and data is valid' do
          before do 
            post "/blogs/#{blog1.id}/posts", params: { title: title1 }, headers: headers1
          end
          
          it 'responds :created' do
            expect(response).to have_http_status(:created)
          end
          
          it 'contains fields from params' do
            json_response = JSON.parse(response.body)
            expect(json_response["title"]).to eq(title1)
            expect(json_response["blog_id"]).to eq(blog1.id)
            expect(json_response["user_id"]).to eq(blog_registred_user1.id)
          end
        end

        context 'and data is invalid' do
          before do 
            post "/blogs/#{blog1.id}/posts", params: { title: '' }, headers: headers1
          end
          
          it 'responds :created' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
          
          it 'contains fields from params' do
            json_response = JSON.parse(response.body)
            expect(json_response["error_message"]).to eq("Post not created")
          end
        end
      end
        
      context "and is not blog owner" do
        before do 
          post "/blogs/#{blog1.id}/posts", params: { title: title2 }, headers: headers2
        end
        
        it 'responds :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context '3.i - when admin user' do
      let!(:blog1) { create(:blog, :with_admin_user) }
      let!(:blog_admin_user1) { blog1.user }
    
      let!(:token1) { JsonWebToken.encode(user_id: blog_admin_user1.id) }
      
      let!(:headers1) { 
        { "Authorization" => token1 } 
      }
    
      let!(:blog2) { create(:blog, :with_admin_user) }
      let!(:blog_admin_user2) { blog2.user }
    
      let!(:token2) { JsonWebToken.encode(user_id: blog_admin_user2.id) }
      
      let!(:headers2) { 
        { "Authorization" => token2 } 
      }
      
      context "and is blog owner" do
        before do 
          post "/blogs/#{blog1.id}/posts", params: { title: title1 }, headers: headers1
        end
        
        it 'responds :created' do
          expect(response).to have_http_status(:created)
        end
    
        it 'contains fields from params' do
          json_response = JSON.parse(response.body)
          expect(json_response["title"]).to eq(title1)
          expect(json_response["blog_id"]).to eq(blog1.id)
          expect(json_response["user_id"]).to eq(blog_admin_user1.id)
        end
      end

      context "and is not blog owner" do
        before do 
          post "/blogs/#{blog1.id}/posts", params: { title: title2 }, headers: headers2
        end
        
        it 'responds :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe "#destroy" do
    let!(:admin_user_blog1) { create(:blog, :with_admin_user) }
    let!(:admin_user1) { admin_user_blog1.user }
    let!(:admin_post1) { create(:post, blog: admin_user_blog1, user: admin_user1)  }
    let!(:admin_user_token1) { JsonWebToken.encode(user_id: admin_user1.id) }
    
    let!(:admin_user_headers1) { 
      { "Authorization" => admin_user_token1 } 
    }

    let!(:admin_user_blog2) { create(:blog, :with_admin_user) }
    let!(:admin_user2) { admin_user_blog2.user }
    let!(:admin_post2) { create(:post, blog: admin_user_blog2, user: admin_user2)  }

    let!(:registred_user_blog1) { create(:blog, :with_registred_user) }
    let!(:registred_user1) { registred_user_blog1.user }
    let!(:registred_post1) { create(:post, blog: registred_user_blog1, user: registred_user1) }
    let!(:post2) { create(:post, blog: registred_user_blog1, user: admin_user1) }
    let!(:registred_user_token1) { JsonWebToken.encode(user_id: registred_user1.id) }

    let!(:registred_user_headers1) { 
      { "Authorization" => registred_user_token1 } 
    }

    context 'when blog not found' do
      before do 
        delete "/blogs/#{admin_user_blog1.id}/posts/-1", headers: admin_user_headers1
      end
      
      it 'responds :not_found' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context '2.iii - when user is registred' do
      context 'it destroys' do
        context 'when post belongs to himself' do
          before do 
            delete "/blogs/#{registred_user_blog1.id}/posts/#{registred_post1.id}", headers: registred_user_headers1
          end
          
          it 'responds :no_content' do
            expect(response).to have_http_status(:no_content)
          end
        end
      end

      context 'it does NOT destroys' do
        context 'when post belongs other user' do
          before do 
            delete "/blogs/#{registred_user_blog1.id}/posts/#{post2.id}", headers: registred_user_headers1
          end
          
          it 'responds :unauthorized' do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end

    context '3.iii - when user is admin' do
      context 'it destroys' do
        context 'when post belongs to himself' do
          before do 
            delete "/blogs/#{admin_user_blog1.id}/posts/#{admin_post1.id}", headers: admin_user_headers1
          end
          
          it 'responds :no_content' do
            expect(response).to have_http_status(:no_content)
          end
        end

        context 'when post belongs to registred user' do
          before do 
            delete "/blogs/#{registred_user_blog1.id}/posts/#{registred_post1.id}", headers: admin_user_headers1
          end
          
          it 'responds :no_content' do
            expect(response).to have_http_status(:no_content)
          end
        end
      end

      context 'it does NOT destroys' do
        context 'when post belongs other admin user' do
          before do 
            delete "/blogs/#{admin_user_blog2.id}/posts/#{admin_post2.id}", headers: admin_user_headers1
          end
          
          it 'responds :unauthorized' do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end
  end

  describe '#show' do
    let!(:user_blog1) { create(:blog, :public) }
    let!(:user1) { user_blog1.user }
    let!(:post1) { create(:post, blog: user_blog1, user: user1)  }
    let!(:user_token1) { JsonWebToken.encode(user_id: user1.id) }
    
    let!(:user_headers1) { 
      { "Authorization" => user_token1 } 
    }

    context '1.i - when user is non-registered' do
      context 'and blog is public' do
        let!(:public_blog) { create(:blog, :public) }
        let!(:public_user) { user_blog1.user }
        let!(:public_post) { create(:post, blog: public_blog, user: public_user)  }

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
        let!(:private_post) { create(:post, blog: private_blog, user: private_user)  }
        
        before do 
          get "/blogs/#{private_blog.id}/posts/#{private_post.id}"
        end
        
        it 'responds :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when user is registered' do
      let!(:registered_blog) { create(:blog, :with_registred_user, :private) }
      let!(:registered_user) { registered_blog.user }
      let!(:registered_post) { create(:post, blog: registered_blog, user: registered_user)  }
      let!(:registered_token) { JsonWebToken.encode(user_id: registered_user.id) }
  
      let!(:registered_headers) { 
        { "Authorization" => registered_token } 
      }

      context 'and blog belongs to himself' do
        before do 
          get "/blogs/#{registered_blog.id}/posts/#{registered_post.id}", headers: registered_headers
        end
        
        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'and blog belongs to another user' do
        before do 
          get "/blogs/#{user_blog1.id}/posts/#{post1.id}", headers: registered_headers
        end
        
        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'when user is admin' do
      let!(:admin_user_blog) { create(:blog, :with_admin_user) }
      let!(:admin_user) { admin_user_blog.user }
      let!(:admin_user_token) { JsonWebToken.encode(user_id: admin_user.id) }
      let!(:admin_post) { create(:post, blog: admin_user_blog, user: admin_user)  }

      
      let!(:admin_user_headers) { 
        { "Authorization" => admin_user_token } 
      }

      context 'and blog belongs to himself' do
        before do 
          get "/blogs/#{admin_user_blog.id}/posts/#{admin_post.id}", headers: admin_user_headers
        end
        
        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'and blog belongs to another user' do
        before do 
          get "/blogs/#{user_blog1.id}/posts/#{post1.id}", headers: admin_user_headers
        end
        
        it 'responds :ok' do
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
