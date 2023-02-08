require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do 
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'validations' do 
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
    it { should validate_numericality_of :unit_price }
    it { should validate_numericality_of :merchant_id }
  end

  describe 'destroy' do
    it 'will destroy the invoice if the deleted item is only item on the invoice' do 
      customer = Customer.create!(first_name: "Charlie", last_name: "Jones")
      invoice1 = Invoice.create!(customer_id: customer.id, status: 2) # one item
      invoice2 = Invoice.create!(customer_id: customer.id, status: 2) # two items
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id)
      ii_1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id)
      ii_2 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice2.id)
      ii_3 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice2.id)

      expect(Item.count).to eq(2)
      expect(Invoice.count).to eq(2)
      expect(InvoiceItem.count).to eq(3)

      item1.destroy

      expect(Item.count).to eq(1)
      expect(Invoice.count).to eq(1)
      expect(InvoiceItem.count).to eq(1)
    end
  end 

  describe 'find_all_items_search' do 
    before :each do 
      @item_1 = create(:item, name: "Beans Aplenty", description: "It's great")
      @item_2 = create(:item, name: "It's a Bean World", description: "not so bad")
      @item_3 = create(:item, name: "Holler Mountain", description: "yummy")
      @item_4 = create(:item, name: "Happy Place", description: "just okay")
      @item_5 = create(:item, name: "Coffee", description: "This darkest roast is beantastic!")
      @item_6 = create(:item, name: "Cool Coffee", description: "You are going to love these coffee seeds!")
    end
  
    it 'will return all items with a matching name or description' do 
      expect(Item.find_all_items_search("Bean")).to eq([@item_1, @item_2, @item_5])
    end

    it 'can return results with a case-insensative name search' do 
      expect(Item.find_all_items_search("beAN")).to eq([@item_1, @item_2, @item_5])
    end

    it 'will not return a search error object if nothing entered in the search' do 
      expect(Item.find_all_items_search("")).to eq(nil)
    end
  end
end
