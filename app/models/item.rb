class Item < ApplicationRecord 
  belongs_to :merchant
  has_many :invoice_items, dependent: :delete_all
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices

  validates_presence_of :name, :description, :unit_price, :merchant_id
  validates_numericality_of :unit_price, :merchant_id

  before_destroy :destroy_invoice_with_single_item, prepend: true
  
  def self.find_all_items_search(search)
    # binding.pry
  end

  private 

  def destroy_invoice_with_single_item
    invoices.each do |invoice|
      if invoice.items.count == 1
        invoice.destroy
      end
    end
  end
end