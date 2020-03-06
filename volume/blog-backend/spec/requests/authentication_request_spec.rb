require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  describe '#login' do
    let!(:user) { create :user }

    context 'When receive matching username and password' do
      before do
        post '/auth/login', params: { username: user.username, password: user.password }
      end

      it 'responds :created' do
        expect(response).to have_http_status(:ok)
      end

      it "responds with user's username" do
        json_response = JSON.parse(response.body)
        expect(json_response['username']).to eq(user.username)
      end

      it "responds with user's access_level" do
        json_response = JSON.parse(response.body)
        expect(json_response['access_level']).to eq(user.access_level)
      end

      it 'responds with a token related to the user id' do
        json_response = JSON.parse(response.body)
        payload = decode_token(json_response['token'])

        expect(payload[:user_id]).to eq(user.id)
      end
    end

    context 'When receive NOT matching username and password' do
      context 'when invalid username and password' do
        before do
          post '/auth/login', params: { username: 'invalid username', password: 'invalid passowrd' }
        end
        it 'responds :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when valid username and invalid password' do
        before do
          post '/auth/login', params: { username: user.username, password: 'invalid passowrd' }
        end
        it 'responds :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'when invalid username and valid password' do
        before do
          post '/auth/login', params: { username: 'invalid username', password: user.password }
        end
        it 'responds :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
