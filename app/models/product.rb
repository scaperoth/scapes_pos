class Product < ActiveRecord::Base
  has_many :sale_details
  has_many :sales, through: :sales
  belongs_to :brand
  belongs_to :category
  belongs_to :team
end
