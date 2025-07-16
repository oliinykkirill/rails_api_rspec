require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    let(:product) { build(:product) }

    it 'is valid with valid attributes' do
      expect(product).to be_valid
    end

    it 'is invalid with a negative price' do
      product.price = -1
      expect(product).not_to be_valid
    end

    it 'is invalid without a title' do
      product.title = nil
      expect(product).not_to be_valid
    end

    it 'is invalid without an associated user' do
      product.user = nil
      expect(product).not_to be_valid
    end
  end
end
