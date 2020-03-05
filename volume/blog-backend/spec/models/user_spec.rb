require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { build :user }
  let!(:user_without_username) { build :user, :without_username }
  let!(:user_without_password) { build :user, :without_password }
  let!(:user_with_invalid_password) { build :user, :without_password }

  it 'is valid when user has all valid fields' do
    expect(user).to be_valid
  end

  context 'when user is invalid' do
    it 'is invalid when user has no username' do
      expect(user_without_username).to be_invalid
    end
    it 'is invalid when user has no password' do
      expect(user_without_password).to be_invalid
    end
    it 'is invalid when user has password with length lesser then 3' do
      expect(user_without_password).to be_invalid
    end

    context 'when username already ' do
      let!(:existing_user) { create :user }
      it 'is invalid when user_name already exists' do
        new_user = build :user
        new_user.username = existing_user.username
        expect(new_user).to be_invalid
      end
    end
  end
end
