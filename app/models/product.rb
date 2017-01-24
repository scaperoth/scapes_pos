class Product < ActiveRecord::Base
    has_many :sale_details, inverse_of: :product
    has_many :sales, through: :sale_details
    belongs_to :brand
    belongs_to :category
    belongs_to :team

    accepts_nested_attributes_for :sale_details

    validates :sku, uniqueness: { scope: :team }

    def self.search(search, page)
        paginate(per_page: 30, page: page).where('description like ?', "%#{search}%").order('description')
    end
end
