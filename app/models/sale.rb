class Sale < ActiveRecord::Base
    belongs_to :customer
    belongs_to :event
    belongs_to :user
    has_many :sale_details
    has_many :products, through: :sale_details
    accepts_nested_attributes_for :sale_details, allow_destroy: true

    def subtotals
        sale_details.map(&:subtotal)
    end

    def total_all
        subtotals.sum
    end
end
