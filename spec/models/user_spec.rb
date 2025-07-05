require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { build(:user, email: 'test@example.com', password: 'password123') }

    it 'is valid with valid email and password' do
      expect(user).to be_valid
    end

    it 'is invalid with invalid email format' do
      user.email = 'invalid-email'
      expect(user).not_to be_valid
    end

    it 'is invalid with duplicate email' do
      create(:user, email: 'duplicate@example.com')
      duplicate_user = build(:user, email: 'duplicate@example.com')
      expect(duplicate_user).not_to be_valid
    end

    it 'is invalid when password confirmation does not match' do
      user.password_confirmation = 'mismatch'
      expect(user).not_to be_valid
    end
  end
end
