require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do 
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do 
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
    it { should validate_numericality_of :unit_price }
    it { should validate_numericality_of :merchant_id }
  end

  describe 'find_all_items_search' do 
    before :each do 
      @item_1 = create(:item, name: "Beans Aplenty")
      @item_2 = create(:item, name: "It's a Bean World")
      @item_3 = create(:item, name: "Holler Mountain")
      @item_4 = create(:item, name: "Happy Place")
      @item_5 = create(:item, description: "This darkest roast is beantastic!")
      @item_6 = create(:item, description: "You are going to love these coffee seeds!")
    end
  
    xit 'will return all items with a matching name or description' do 
      expect(Item.find_all_items_search("Bean")).to eq([@item_1, @item_2, @item_5])
    end

    xit 'can return results with a case-insensative name search' do 

    end
  end
end
