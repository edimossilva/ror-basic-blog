require 'rails_helper'

RSpec.describe "Blogs", type: :request do
  describe "#create" do
    context "When receive valida data" do
      let!(:name) { Faker::Name.name }
      let!(:is_private) { Faker::Boolean.boolean }
      
      before do 
        post "/blogs", params: { name: name, is_private: is_private }
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
      let!(:invalid_name) { "" }
      let!(:is_private) { Faker::Boolean.boolean }
      
      before do 
        post "/blogs", params: { name: invalid_name, is_private: is_private }
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
