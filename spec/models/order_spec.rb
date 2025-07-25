require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  let(:product1) { create(:product, user: user, price: 50, quantity: 10) }
  let(:product2) { create(:product, user: user, price: 25, quantity: 5) }
  let(:order) { build(:order, user: user) }

  describe 'stock validation and total calculation' do
    it 'calculates total based on placement prices and quantities' do
      order.placements = [
        Placement.new(product: product1, quantity: 2),
        Placement.new(product: product2, quantity: 3)
      ]
      order.set_total!
      expect(order.total).to eq(175.0)
    end

    it 'is invalid when placement requests more quantity than in stock' do
      order.placements << Placement.new(product: product2, quantity: 99)
      expect(order).not_to be_valid
    end
  end
end
