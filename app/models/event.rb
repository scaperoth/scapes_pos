class Event < ActiveRecord::Base
  has_many :sales
  belongs_to :team
  
  validates :name, uniqueness: { scope: :team }
end
