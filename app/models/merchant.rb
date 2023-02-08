class Merchant < ApplicationRecord 
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.find_merchant(search)
    if search != ""
      where("lower(name) LIKE ?", 
        sanitize_sql_for_conditions("%" + search.downcase + "%"))
        .order(:name).first
    else 
      nil
    end 
  end
end