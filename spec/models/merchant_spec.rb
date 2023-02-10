require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do 
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'merchant search' do 
    before :each do 
      @merchant_1 = create(:merchant, name: "World of Coffee")
      @merchant_2 = create(:merchant, name: "Hello World")
      @merchant_3 = create(:merchant, name: "Ring World")
      @merchant_4 = create(:merchant, name: "Happy Place")
    end
  
    it 'will return a single merchant by alphabetical order if multiple results found' do 
      expect(Merchant.find_merchant("World")).to eq(@merchant_2)
    end

    it 'can do a case-insensative search' do 
      expect(Merchant.find_merchant("worLD")).to eq(@merchant_2)
    end

    it 'will not return a search error object if nothing entered in the search' do 
      expect(Merchant.find_merchant("")).to eq(nil)
    end
  end 
end
