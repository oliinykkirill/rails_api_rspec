require 'rails_helper'

RSpec.describe 'Api::V1::Products', type: :request do
  let!(:product) { create(:product) }

  describe 'GET /api/v1/products' do
    it 'returns the list of all products' do
      get api_v1_products_url, as: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/products/:id' do
    it 'returns a single product' do
      get api_v1_product_url(product), as: :json
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq(product.title)
    end
  end
end
