require 'rails_helper'

RSpec.describe 'Api::V1::Products', type: :request do
  let!(:user) { create(:user) }
  let!(:product) { create(:product, user: user) }

  describe 'GET /api/v1/products/:id' do
    it 'returns serialized product with embedded user in JSON:API include' do
      get api_v1_product_url(product), as: :json
      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json.dig(:data, :attributes, :title)).to eq(product.title)
      expect(json.dig(:data, :relationships, :user, :data, :id)).to eq(user.id.to_s)
      expect(json.dig(:included, 0, :attributes, :email)).to eq(user.email)
    end
  end
end
