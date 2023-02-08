require 'rails_helper'

RSpec.describe 'Items Search' do 
  before :each do 
    @item_1 = create(:item, name: "Beans Aplenty")
    @item_2 = create(:item, name: "It's a Bean World")
    @item_3 = create(:item, name: "Holler Mountain")
    @item_4 = create(:item, name: "Happy Place")
    @item_5 = create(:item, description: "Darkest roast beans")
    @item_6 = create(:item, description: "You are going to love these coffee seeds!")
  end

  it 'will return all items with a matching name or description' do 
    get '/api/v1/items/find_all?name=Bean'
  end

  xit 'can return results with a case-insensative name search' do 

  end

  xit 'price query... ' do 

  end

  xit 'will return an array of objects with zero or one match found' do 

  end

  xit 'will return a 404 if no matches are found' do 

  end
end
