require 'rails_helper'

RSpec.describe JsonWebToken do
  let(:payload) { { user_id: 1 } }
  let(:token) { described_class.encode(payload) }

  describe '.encode and .decode' do
    it 'encodes and decodes the payload accurately' do
      decoded = described_class.decode(token)
      expect(decoded[:user_id]).to eq(1)
      expect(decoded[:exp]).to be_present
    end

    it 'raises verification error on invalid secret' do
      invalid_token = JWT.encode(payload, 'wrong_key')
      expect {
        described_class.decode(invalid_token)
      }.to raise_error(JWT::VerificationError)
    end
  end
end
