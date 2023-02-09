require 'rails_helper'

RSpec.describe 'Items Search' do 
  before :each do 
    @item_1 = create(:item, name: "Beans Aplenty", description: "It's great", unit_price: 8.99)
    @item_2 = create(:item, name: "It's a Bean World", description: "not so bad", unit_price: 25.48)
    @item_3 = create(:item, name: "Holler Mountain", description: "yummy", unit_price: 4.44)
    @item_4 = create(:item, name: "Happy Place", description: "just okay", unit_price: 10.99)
    @item_5 = create(:item, name: "Coffee", description: "This darkest roast is beantastic!", unit_price: 30.99)
    @item_6 = create(:item, name: "Cool Coffee", description: "You are going to love these coffee seeds!", unit_price: 12.12)
  end

  it 'will return all items with a matching name or description' do 
    get '/api/v1/items/find_all?name=Bean'

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items).to have_key(:data)
    expect(items[:data]).to be_an(Array)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item| 
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it 'can return results with a case-insensative name search' do 
    get '/api/v1/items/find_all?name=beAn'

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items).to have_key(:data)
    expect(items[:data]).to be_an(Array)

    expect(items[:data].count).to eq(3)
  end

  it 'will return all items that are less than or equal to min price search query' do 
    get '/api/v1/items/find_all?min_price=10.99'

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items).to have_key(:data)
    expect(items[:data]).to be_an(Array)

    expect(items[:data].count).to eq(3)
  end

  it 'will return all items that are more than or equal to max price search query' do 
    get '/api/v1/items/find_all?max_price=8.00'

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items).to have_key(:data)
    expect(items[:data]).to be_an(Array)

    expect(items[:data].count).to eq(5)
  end

  it 'min AND max price query' do 
    get '/api/v1/items/find_all?min_price=10.99&max_price=28.00'

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items).to have_key(:data)
    expect(items[:data]).to be_an(Array)

    expect(items[:data].count).to eq(4)
  end

  it 'error if name and price query entered' do 
    get '/api/v1/items/find_all?name=bean&max_price=28.00'
    
    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to be_an(Array)

    expect(error_response[:errors][0]).to have_key(:status)
    expect(error_response[:errors][0][:status]).to be_a(String)

    expect(error_response[:errors][0]).to have_key(:message)
    expect(error_response[:errors][0][:message]).to be_a(String)
    
    expect(error_response[:errors][0]).to have_key(:code)
    expect(error_response[:errors][0][:code]).to be_an(Integer)
  end

  it 'will return an array of objects with zero or one match found' do 
    get '/api/v1/items/find_all?name=Mountain'

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items).to have_key(:data)
    expect(items[:data]).to be_an(Array)

    expect(items[:data].count).to eq(1)

    get '/api/v1/items/find_all?name=xkad;kfjadi'

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items).to have_key(:data)
    expect(items[:data]).to be_an(Array)

    expect(items[:data].count).to eq(0)

    get '/api/v1/items/find_all?min_price=5.00' 
    
    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items).to have_key(:data)
    expect(items[:data]).to be_an(Array)

    expect(items[:data].count).to eq(1)
  
    get '/api/v1/items/find_all?max_price=45.25' 
    
    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items).to have_key(:data)
    expect(items[:data]).to be_an(Array)

    expect(items[:data].count).to eq(0)  
  end

  it 'will return an error message if no query params entered' do 
    get '/api/v1/items/find_all?'

    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to be_an(Array)

    expect(error_response[:errors][0]).to have_key(:status)
    expect(error_response[:errors][0][:status]).to be_a(String)

    expect(error_response[:errors][0]).to have_key(:message)
    expect(error_response[:errors][0][:message]).to be_a(String)
    
    expect(error_response[:errors][0]).to have_key(:code)
    expect(error_response[:errors][0][:code]).to be_an(Integer)
  end

  it 'will return an error message if nothing entered in query' do 
    get '/api/v1/items/find_all?name='

    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to be_an(Array)

    expect(error_response[:errors][0]).to have_key(:status)
    expect(error_response[:errors][0][:status]).to be_a(String)

    expect(error_response[:errors][0]).to have_key(:message)
    expect(error_response[:errors][0][:message]).to be_a(String)
    
    expect(error_response[:errors][0]).to have_key(:code)
    expect(error_response[:errors][0][:code]).to be_an(Integer)
  end
end
