require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let!(:user) { create(:user) }

  describe 'GET /api/v1/users/:id' do
    it 'returns the user email and 200 OK' do
      get api_v1_user_url(user), as: :json
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response['email']).to eq(user.email)
    end
  end

  describe 'POST /api/v1/users' do
    let(:valid_params) { { user: { email: 'newuser@example.com', password: 'secretpassword' } } }
    let(:invalid_params) { { user: { email: user.email, password: 'secretpassword' } } }

    it 'creates a new user and returns 201 Created' do
      expect {
        post api_v1_users_url, params: valid_params, as: :json
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it 'returns 422 Unprocessable Entity on duplicate email' do
      expect {
        post api_v1_users_url, params: invalid_params, as: :json
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
