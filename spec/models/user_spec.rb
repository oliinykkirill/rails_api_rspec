require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    let(:user) { create(:user) }
    let!(:product) { create(:product, user: user) }

    it 'destroys associated products upon user destruction' do
      expect {
        user.destroy
      }.to change(Product, :count).by(-1)
    end
  end
end
