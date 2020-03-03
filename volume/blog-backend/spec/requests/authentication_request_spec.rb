require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  describe "#login" do
    let!(:user) { create :user }

    context "When receive valid data" do
      before do 
        post "/auth/login", params: { username: user.username, password: user.password }
      end

      it 'responds :created' do
        expect(response).to have_http_status(:ok)
      end

      it "responds with user's username" do
        json_response = JSON.parse(response.body)
        expect(json_response["username"]).to eq(user.username)
      end

      it "responds with a token related to the user id" do
        json_response = JSON.parse(response.body)
        payload = JsonWebToken.decode(json_response["token"])

        expect(payload[:user_id]).to eq(user.id)
      end
    end
  end
end
