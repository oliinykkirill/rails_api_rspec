require 'rails_helper'

RSpec.describe 'Api::V1::Tokens', type: :request do
  let!(:user) { create(:user, password: 'password123') }

  describe 'POST /api/v1/tokens' do
    it 'returns a JWT token with valid credentials' do
      post api_v1_tokens_url, params: { user: { email: user.email, password: 'password123' } }, as: :json
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response['token']).to be_present
      expect(json_response['email']).to eq(user.email)
    end

    it 'returns 401 Unauthorized with invalid password' do
      post api_v1_tokens_url, params: { user: { email: user.email, password: 'wrong' } }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
