class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.text :name, default: 'Anonymous'
      t.timestamps
    end
  end
end
