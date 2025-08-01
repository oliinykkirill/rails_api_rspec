require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let!(:user) { create(:user) }
  let(:auth_header) { { 'Authorization' => JsonWebToken.encode(user_id: user.id) } }

  describe 'GET /api/v1/users/:id' do
    it 'returns serialized JSON:API user attributes' do
      get api_v1_user_url(user), as: :json
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response['data']['attributes']['email']).to eq(user.email)
    end
  end

  describe 'POST /api/v1/users' do
    it 'creates a user with valid params' do
      user_params = { user: { email: 'new_user@example.com', password: 'password123' } }
      expect {
        post api_v1_users_url, params: user_params, as: :json
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json.dig(:data, :attributes, :email)).to eq('new_user@example.com')
    end

    it 'returns unprocessable entity with taken email' do
      user_params = { user: { email: user.email, password: 'password123' } }
      post api_v1_users_url, params: user_params, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /api/v1/users/:id' do
    let(:other_user) { create(:user) }
    let(:other_header) { { 'Authorization' => JsonWebToken.encode(user_id: other_user.id) } }

    it 'updates user when owner' do
      patch api_v1_user_url(user),
            params: { user: { email: 'updated@example.com' } },
            headers: auth_header,
            as: :json
      expect(response).to have_http_status(:ok)
      expect(user.reload.email).to eq('updated@example.com')
    end

    it 'returns unprocessable entity when update params are invalid' do
      patch api_v1_user_url(user),
            params: { user: { email: 'bad_email' } },
            headers: auth_header,
            as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'forbids update from non-owner' do
      patch api_v1_user_url(user),
            params: { user: { email: 'hacked@example.com' } },
            headers: other_header,
            as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    let(:other_user) { create(:user) }
    let(:other_header) { { 'Authorization' => JsonWebToken.encode(user_id: other_user.id) } }

    it 'deletes user when owner' do
      expect {
        delete api_v1_user_url(user), headers: auth_header, as: :json
      }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'forbids deletion from non-owner' do
      delete api_v1_user_url(user), headers: other_header, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end
end
