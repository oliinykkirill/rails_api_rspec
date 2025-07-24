require 'rails_helper'

RSpec.describe OrderMailer, type: :mailer do
  describe 'send_confirmation' do
    let(:user) { create(:user) }
    let(:product) { create(:product, user: user) }
    let(:order) { create(:order, user: user, products: [product]) }
    let(:mail) { described_class.send_confirmation(order) }

    it 'renders headers and body correctly' do
      expect(mail.subject).to eq('Order Confirmation')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['no-reply@marketplace.com'])
      expect(mail.body.encoded).to match("Order: ##{order.id}")
      expect(mail.body.encoded).to match("You ordered 1 products")
    end
  end
end
