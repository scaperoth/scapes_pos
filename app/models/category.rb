class Category < ActiveRecord::Base
  has_one :team
  has_many :products
end
