require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations and associations' do
    let(:order) { build(:order) }

    it 'is valid with positive total' do
      expect(order).to be_valid
    end

    it 'is invalid with negative total' do
      order.total = -10
      expect(order).not_to be_valid
    end
  end
end
