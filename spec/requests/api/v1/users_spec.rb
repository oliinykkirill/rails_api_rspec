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

    it 'creates a new user and returns 201 Created' do
      expect {
        post api_v1_users_url, params: valid_params, as: :json
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'PATCH /api/v1/users/:id' do
    it 'updates user email successfully' do
      patch api_v1_user_url(user), params: { user: { email: 'updated@example.com' } }, as: :json
      expect(response).to have_http_status(:ok)
      expect(user.reload.email).to eq('updated@example.com')
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    it 'destroys user and returns 204 No Content' do
      expect {
        delete api_v1_user_url(user), as: :json
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
