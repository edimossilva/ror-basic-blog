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
end
