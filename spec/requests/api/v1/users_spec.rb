require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let(:auth_header) { { 'Authorization' => JsonWebToken.encode(user_id: user.id) } }

  describe 'GET /api/v1/users/:id' do
    it 'returns user email and 200 OK' do
      get api_v1_user_url(user), as: :json
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response['email']).to eq(user.email)
    end
  end

  describe 'POST /api/v1/users' do
    let(:valid_params) { { user: { email: 'newuser@example.com', password: 'secretpassword' } } }

    it 'creates a new user' do
      expect {
        post api_v1_users_url, params: valid_params, as: :json
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'PATCH /api/v1/users/:id' do
    it 'updates user when authenticated as owner' do
      patch api_v1_user_url(user),
        params: { user: { email: 'updated@example.com' } },
        headers: auth_header,
        as: :json
      expect(response).to have_http_status(:ok)
      expect(user.reload.email).to eq('updated@example.com')
    end

    it 'forbids update without authorization' do
      patch api_v1_user_url(user), params: { user: { email: 'forbidden@example.com' } }, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    it 'destroys user when authenticated as owner' do
      expect {
        delete api_v1_user_url(user), headers: auth_header, as: :json
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it 'forbids destroy without authorization' do
      expect {
        delete api_v1_user_url(user), as: :json
      }.not_to change(User, :count)

      expect(response).to have_http_status(:forbidden)
    end
  end
end
