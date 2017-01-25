class Sale < ActiveRecord::Base
    belongs_to :customer
    belongs_to :event
    belongs_to :user
    has_many :sale_details
    has_many :products, through: :sale_details
    accepts_nested_attributes_for :sale_details, allow_destroy: true
    
    before_save :set_change
    
    validate :amount_paid_cannot_be_less_than_total
 
  def amount_paid_cannot_be_less_than_total
    if amount_paid < total_all
      errors.add(:missing_payment, "Amount paid must be greater than or equal to total!")
    end
  end
  
    def set_change
      self.change = self.amount_paid - self.total 
    end
    
    def subtotals
        sale_details.map(&:subtotal)
    end

    def total_all
        subtotals.sum
    end
end
