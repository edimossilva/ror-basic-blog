require 'rails_helper'

RSpec.describe "Blogs", type: :request do
  describe "#create" do
    let!(:name) { Faker::Name.name }
    let!(:is_private) { Faker::Boolean.boolean }
    let!(:user) { create :user }
    let!(:regular_token) { JsonWebToken.encode(user_id: user.id) }
    let!(:invalid_token) { JsonWebToken.encode(user_id: -1) }
    
    let!(:headers) { 
      { "Authorization" => regular_token } 
    }
    let!(:invalid_decode_headers) { 
      { "Authorization" => "invalid_token" } 
    }
    let!(:invalid_user_id_headers) { 
      { "Authorization" => invalid_token } 
    }

    context "When receive valida data" do
      before do 
        post "/blogs", params: { name: name, is_private: is_private }, headers: headers
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
            post "/blogs", params: { name: name, is_private: is_private }, headers: invalid_decode_headers
          end
          it 'responds :unauthorized' do
            expect(response).to have_http_status(:unauthorized)
          end
        end
        
        context 'when user is not' do
          before do 
            post "/blogs", params: { name: name, is_private: is_private }, headers: invalid_user_id_headers
          end
          it 'responds :unauthorized' do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end

      context 'when blog data is invalid' do
        before do 
          post "/blogs", params: { name: "", is_private: is_private }, headers: headers
        end
        
        it 'responds :unprocessable_entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
  
        it 'contains error messages' do
          json_response = JSON.parse(response.body)
          expect(json_response["error_message"]).to eq("Blog not created")
          expect(json_response["errors"].length).to eq(1)
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
    end
  end
end
