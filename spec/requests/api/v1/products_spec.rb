require 'rails_helper'

RSpec.describe 'Api::V1::Products', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:product) { create(:product, user: user) }
  let(:auth_header) { { 'Authorization' => JsonWebToken.encode(user_id: user.id) } }

  describe 'GET /api/v1/products' do
    it 'returns products list' do
      get api_v1_products_url, as: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/products/:id' do
    it 'returns product data' do
      get api_v1_product_url(product), as: :json
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq(product.title)
    end
  end

  describe 'POST /api/v1/products' do
    let(:product_params) { { product: { title: 'Smartphone', price: 699.99, published: true } } }

    it 'creates product when authenticated' do
      expect {
        post api_v1_products_url, params: product_params, headers: auth_header, as: :json
      }.to change(Product, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'forbids creation without authentication' do
      post api_v1_products_url, params: product_params, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PATCH /api/v1/products/:id' do
    it 'updates product when owner' do
      patch api_v1_product_url(product), params: { product: { title: 'Updated Title' } }, headers: auth_header, as: :json
      expect(response).to have_http_status(:ok)
      expect(product.reload.title).to eq('Updated Title')
    end

    it 'forbids update when not owner' do
      other_auth = { 'Authorization' => JsonWebToken.encode(user_id: other_user.id) }
      patch api_v1_product_url(product), params: { product: { title: 'Hacked' } }, headers: other_auth, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /api/v1/products/:id' do
    it 'destroys product when owner' do
      expect {
        delete api_v1_product_url(product), headers: auth_header, as: :json
      }.to change(Product, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
