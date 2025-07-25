require 'rails_helper'

RSpec.describe Placement, type: :model do
  describe '#decrement_product_quantity!' do
    let(:product) { create(:product, quantity: 10) }
    let(:placement) { build(:placement, product: product, quantity: 4) }

    it 'decreases product stock by placement quantity' do
      expect {
        placement.decrement_product_quantity!
      }.to change { product.reload.quantity }.from(10).to(6)
    end
  end
end
