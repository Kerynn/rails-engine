require 'rails_helper'

RSpec.describe 'Merchant Search' do 
  before :each do 
    @merchant_1 = create(:merchant, name: "World of Coffee")
    @merchant_2 = create(:merchant, name: "Hello World")
    @merchant_3 = create(:merchant, name: "Ring World")
    @merchant_4 = create(:merchant, name: "Happy Place")
  end

  it 'will return a single object in alphabetical order' do 
    get '/api/v1/merchants/find'

    
  end

  xit 'can do a case_insensative search' do 

  end
end