class AddProductsListToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :products_list, :text
  end
end
