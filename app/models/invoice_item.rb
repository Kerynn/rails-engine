class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :merchants, through: :item 

  enum status: ['pending', 'packaged', 'shipped']
end 