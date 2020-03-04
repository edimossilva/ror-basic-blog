require 'rails_helper'

RSpec.describe "Posts", type: :request do

  let!(:title1) { Faker::Books::CultureSeries.book }
  let!(:title2) { Faker::Books::CultureSeries.book }
  
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
