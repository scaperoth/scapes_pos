class Category < ActiveRecord::Base
  belongs_to :team
  has_many :products
  
  validates :name, uniqueness: { scope: :team }
end
