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
end
