class AddQuantityToDoses < ActiveRecord::Migration[5.2]
  def change
    add_column :doses, :quantity, :integer
  end
end
