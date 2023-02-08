class Item < ApplicationRecord 
  belongs_to :merchant

  validates_presence_of :name, :description, :unit_price, :merchant_id
  validates_numericality_of :unit_price, :merchant_id

  def self.find_all_items_search(search)
    # binding.pry
  end
end