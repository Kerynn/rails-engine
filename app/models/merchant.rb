class Merchant < ApplicationRecord 
  has_many :items

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