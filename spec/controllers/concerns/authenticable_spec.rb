require 'rails_helper'

class MockController < ApplicationController
  attr_accessor :request

  def initialize
    super
    mock_request = Struct.new(:headers)
    self.request = mock_request.new({})
  end
end

RSpec.describe Authenticable, type: :controller do
  let(:user) { create(:user) }
  let(:controller) { MockController.new }

  describe '#current_user' do
    it 'finds user from valid Authorization token header' do
      controller.request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id)
      expect(controller.current_user).to eq(user)
    end

    it 'returns nil when Authorization header is absent' do
      controller.request.headers['Authorization'] = nil
      expect(controller.current_user).to be_nil
    end

    it 'returns nil when Authorization token is invalid' do
      controller.request.headers['Authorization'] = 'Bearer invalid_token'
      expect(controller.current_user).to be_nil
    end
  end
end
