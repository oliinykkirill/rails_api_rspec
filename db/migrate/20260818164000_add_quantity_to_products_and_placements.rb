class AddQuantityToProductsAndPlacements < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :quantity, :integer, default: 0
    add_column :placements, :quantity, :integer, default: 0
  end
end
