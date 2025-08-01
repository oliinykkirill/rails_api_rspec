require 'rails_helper'

RSpec.describe 'Api::V1::Products', type: :request do
  let!(:user) { create(:user) }
  let!(:product) { create(:product, user: user) }

  let(:auth_header) { { 'Authorization' => JsonWebToken.encode(user_id: user.id) } }

  describe 'GET /api/v1/products' do
    let!(:another_product) { create(:product, title: 'Extra item', user: user) }

    it 'returns paginated list of products with metadata links' do
      get api_v1_products_url, as: :json
      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data].size).to eq(2)
      expect(json[:links]).to be_present
    end

    it 'filters products by search keyword' do
      get api_v1_products_url(keyword: 'Extra'), as: :json
      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data].size).to eq(1)
      expect(json.dig(:data, 0, :attributes, :title)).to eq('Extra item')
    end
  end

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

  describe 'POST /api/v1/products' do
    it 'creates a product when logged in' do
      product_params = { product: { title: 'New Gadget', price: 99.99, published: true } }
      expect {
        post api_v1_products_url, params: product_params, headers: auth_header, as: :json
      }.to change(Product, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json.dig(:data, :attributes, :title)).to eq('New Gadget')
    end

    it 'returns unprocessable entity for invalid params' do
      product_params = { product: { title: '', price: -10 } }
      post api_v1_products_url, params: product_params, headers: auth_header, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'forbids creation when unauthenticated' do
      product_params = { product: { title: 'Unauthorized item', price: 10 } }
      post api_v1_products_url, params: product_params, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PATCH /api/v1/products/:id' do
    let(:other_user) { create(:user) }
    let(:other_header) { { 'Authorization' => JsonWebToken.encode(user_id: other_user.id) } }

    it 'updates product when owner' do
      patch api_v1_product_url(product),
            params: { product: { title: 'Updated Title' } },
            headers: auth_header,
            as: :json
      expect(response).to have_http_status(:ok)
      expect(product.reload.title).to eq('Updated Title')
    end

    it 'returns unprocessable entity for invalid update' do
      patch api_v1_product_url(product),
            params: { product: { price: -5 } },
            headers: auth_header,
            as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'forbids update by non-owner' do
      patch api_v1_product_url(product),
            params: { product: { title: 'Hacked' } },
            headers: other_header,
            as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /api/v1/products/:id' do
    let(:other_user) { create(:user) }
    let(:other_header) { { 'Authorization' => JsonWebToken.encode(user_id: other_user.id) } }

    it 'deletes product when owner' do
      expect {
        delete api_v1_product_url(product), headers: auth_header, as: :json
      }.to change(Product, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'forbids delete by non-owner' do
      delete api_v1_product_url(product), headers: other_header, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end
end
