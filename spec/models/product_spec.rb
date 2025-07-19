require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'search scopes' do
    let!(:expensive_tv) { create(:product, title: 'OLED TV', price: 1500) }
    let!(:cheap_tv)     { create(:product, title: 'Budget TV', price: 200) }
    let!(:laptop)       { create(:product, title: 'MacBook Pro', price: 2000) }

    it 'filters products by title keyword' do
      expect(Product.filter_by_title('tv')).to contain_exactly(expensive_tv, cheap_tv)
    end

    it 'filters products above or equal to price' do
      expect(Product.above_or_equal_to_price(1000)).to contain_exactly(expensive_tv, laptop)
    end

    it 'filters products below or equal to price' do
      expect(Product.below_or_equal_to_price(500)).to contain_exactly(cheap_tv)
    end

    it 'executes comprehensive search with multiple filters' do
      results = Product.search(keyword: 'tv', min_price: 100, max_price: 500)
      expect(results).to contain_exactly(cheap_tv)
    end
  end
end
