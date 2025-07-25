class Order < ApplicationRecord
  include ActiveModel::Validations

  before_validation :set_total!

  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  validates_with EnoughProductsValidator

  def set_total!
    self.total = placements.map { |p| p.product.price * p.quantity }.sum
  end

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |item|
      placement = placements.build(
        product_id: item[:product_id],
        quantity: item[:quantity]
      )
      yield placement if block_given?
    end
  end
end
