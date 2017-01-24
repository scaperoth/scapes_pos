class SaleDetail < ActiveRecord::Base
    belongs_to :sale
    belongs_to :product

    before_save :set_total
    
    def set_total
        if quantity.blank?
            0
        else
            self.total = quantity * self.price
        end
    end

    def subtotal
        if quantity.blank?
            0
        else
            quantity * self.price
        end
    end
end
