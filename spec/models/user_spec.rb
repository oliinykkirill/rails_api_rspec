require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { build(:user, email: 'test@example.com') }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'is invalid with invalid email format' do
      user.email = 'invalid-email'
      expect(user).not_to be_valid
    end

    it 'is invalid with a duplicate email' do
      create(:user, email: 'duplicate@example.com')
      duplicate_user = build(:user, email: 'duplicate@example.com')
      expect(duplicate_user).not_to be_valid
    end
  end
end
