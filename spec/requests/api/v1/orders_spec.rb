require 'rails_helper'

RSpec.describe 'Api::V1::Orders', type: :request do
  let!(:user) { create(:user) }
  let!(:product1) { create(:product, user: user, price: 100) }
  let!(:product2) { create(:product, user: user, price: 50) }
  let!(:order) { create(:order, user: user, products: [product1]) }
  let(:auth_header) { { 'Authorization' => JsonWebToken.encode(user_id: user.id) } }

  describe 'GET /api/v1/orders' do
    it 'returns orders for logged in user' do
      get api_v1_orders_url, headers: auth_header, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'forbids unauthenticated access' do
      get api_v1_orders_url, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /api/v1/orders' do
    it 'creates an order with products and calculates total automatically' do
      order_params = {
        order: {
          product_ids_and_quantities: [
            { product_id: product1.id, quantity: 2 },
            { product_id: product2.id, quantity: 3 }
          ]
        }
      }
      expect {
        post api_v1_orders_url, params: order_params, headers: auth_header, as: :json
      }.to change(Order, :count).by(1)
        .and change(Placement, :count).by(2)

      expect(response).to have_http_status(:created)
      expect(Order.last.total).to eq(product1.price * 2 + product2.price * 3)
    end
  end
end
