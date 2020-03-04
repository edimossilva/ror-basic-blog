require 'rails_helper'

RSpec.describe "Blogs", type: :request do
  describe "#create" do
    let!(:name) { Faker::Name.name }
    let!(:is_private) { Faker::Boolean.boolean }
    let!(:user) { create :user }
    let!(:registred_token) { JsonWebToken.encode(user_id: user.id) }
    let!(:invalid_token) { JsonWebToken.encode(user_id: -1) }
    
    let!(:headers) { 
      { "Authorization" => registred_token } 
    }
    let!(:invalid_decode_headers) { 
      { "Authorization" => "invalid_token" } 
    }
    let!(:invalid_user_id_headers) { 
      { "Authorization" => invalid_token } 
    }
    
    context "When receive valida data" do
      before do 
        post "/blogs", params: { name: name, is_private: is_private, user_id: user.id }, headers: headers
      end
      
      it 'responds :created' do
        expect(response).to have_http_status(:created)
      end

      it 'contains fields from params' do
        json_response = JSON.parse(response.body)
        expect(json_response["name"]).to eq(name)
        expect(json_response["is_private"]).to eq(is_private)
      end
    end

    context "When receive invalida data" do
      context 'when token is invalid' do
        context 'when token has invalid decode' do
          before do 
            post "/blogs", params: { name: name, is_private: is_private, user_id: user.id }, headers: invalid_decode_headers
          end
          it 'responds :unauthorized' do
            expect(response).to have_http_status(:unauthorized)
          end
        end
        
        context 'when user is not valid' do
          before do 
            post "/blogs", params: { name: name, is_private: is_private, user_id: user.id }, headers: invalid_user_id_headers
          end
          it 'responds :unauthorized' do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end

      context 'when blog data is invalid' do
        context 'when name is empty' do
          before do 
            post "/blogs", params: { name: "", is_private: is_private, user_id: user.id }, headers: headers
          end
          
          it 'responds :unprocessable_entity' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
    
          it 'contains error messages' do
            json_response = JSON.parse(response.body)
            expect(json_response["error_message"]).to eq("Blog not created")
          end
    
          it 'contains 1 error' do
            json_response = JSON.parse(response.body)
            expect(json_response["errors"].length).to eq(1)
          end
    
          it 'error is name: cant be empty' do
            json_response = JSON.parse(response.body)
            expect(json_response["errors"]["name"][0]).to eq("can't be blank")
          end
        end
        context 'when user_id is empty' do
          before do 
            post "/blogs", params: { name: name, is_private: is_private, user_id: "" }, headers: headers
          end
          
          it 'responds :unprocessable_entity' do
            expect(response).to have_http_status(:unprocessable_entity)
          end
    
          it 'contains error messages' do
            json_response = JSON.parse(response.body)
            expect(json_response["error_message"]).to eq("Blog not created")
          end
    
          it 'contains 1 error' do
            json_response = JSON.parse(response.body)
            expect(json_response["errors"].length).to eq(1)
          end
    
          it 'error is name: cant be empty' do
            json_response = JSON.parse(response.body)
            expect(json_response["errors"]["user"][0]).to eq("must exist")
          end
        end
      end
    end
  end

  describe "#destroy" do
    context 'when blog not found' do
      let!(:admin_user_blog) { create(:blog, :with_admin_user) }
      let!(:admin_user) { admin_user_blog.user }
      let!(:admin_user_token) { JsonWebToken.encode(user_id: admin_user.id) }
      
      let!(:admin_user_headers) { 
        { "Authorization" => admin_user_token } 
      }
      
      before do 
        delete "/blogs/-1", headers: admin_user_headers
      end
      
      it 'responds :not_found' do
        expect(response).to have_http_status(:not_found)
      end
    end
    
    context 'when user is admin' do
      context 'it destroys' do
        context 'when blog belongs to himself' do
          let!(:admin_user_blog) { create(:blog, :with_admin_user) }
          let!(:admin_user) { admin_user_blog.user }
          let!(:admin_user_token) { JsonWebToken.encode(user_id: admin_user.id) }
          
          let!(:admin_user_headers) { 
            { "Authorization" => admin_user_token } 
          }
          
          before do 
            delete "/blogs/#{admin_user_blog.id}", headers: admin_user_headers
          end
          
          it 'responds :no_content' do
            expect(response).to have_http_status(:no_content)
          end
        end
        
        context 'when blog belongs to registred user' do
          let!(:registred_user_blog) { create(:blog, :with_registred_user) }
          
          let!(:admin_user) { create(:user, :admin) }
          let!(:admin_user_token) { JsonWebToken.encode(user_id: admin_user.id) }
          
          let!(:admin_user_headers) { 
            { "Authorization" => admin_user_token } 
          }
          
          before do 
            delete "/blogs/#{registred_user_blog.id}", headers: admin_user_headers
          end
          
          it 'responds :no_content' do
            expect(response).to have_http_status(:no_content)
          end
        end
      end
      context 'it does not destroys' do
        context 'when blog belongs to another admin' do
          let!(:admin_user_blog) { create(:blog, :with_admin_user) }
          let!(:another_admin_user) { create(:user, :admin) }
          let!(:another_admin_user_token) { JsonWebToken.encode(user_id: another_admin_user.id) }
          
          let!(:another_admin_user_headers) { 
            { "Authorization" => another_admin_user_token } 
          }
        
          before do 
            delete "/blogs/#{admin_user_blog.id}", headers: another_admin_user_headers
          end
          
          it 'responds :unauthorized' do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end
  end
end
