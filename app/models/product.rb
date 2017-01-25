class Product < ActiveRecord::Base
    has_many :sale_details
    has_many :sales
    belongs_to :brand
    belongs_to :category
    belongs_to :team

    validates :sku, uniqueness: { scope: :team }

    def self.search(search, page)
        paginate(per_page: 30, page: page).where('description like ?', "%#{search}%").order('description')
    end
end
