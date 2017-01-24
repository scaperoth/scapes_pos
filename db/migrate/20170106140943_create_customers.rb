class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name, default: 'Anonymous'
      t.timestamps
    end
  end
end
