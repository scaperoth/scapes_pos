class AddSearchTermToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :search_term, :string
  end
end
