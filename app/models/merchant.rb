class Merchant < ApplicationRecord 
  has_many :items

  def self.find_merchant(search)
    where("lower(name) LIKE ?", 
      sanitize_sql_for_conditions("%" + search.downcase + "%"))
      .order(:name).first
  end
end