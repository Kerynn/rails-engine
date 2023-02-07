require 'rails_helper'

RSpec.describe 'Items API' do 
  it 'sends a list of items associated with a merchant' do 
    merchant1_id = create(:merchant).id
    item_1 = create(:item, merchant_id: merchant1_id)
    item_2 = create(:item, merchant_id: merchant1_id)
    item_3 = create(:item, merchant_id: merchant1_id)

    merchant2_id = create(:merchant).id
    item_4 = create(:item, merchant_id: merchant2_id)

    get "/api/v1/merchants/#{merchant1_id}/items"

    expect(response).to be_successful

    merchant_items = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_items[:data].count).to eq(3)

    expect(merchant_items).to have_key(:data)
    expect(merchant_items[:data]).to be_an(Array)
    
    merchant_items[:data].each do |item| 
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

  xit 'returns an error if merchant not found' do 
    get "/api/v1/merchants/8/items"

    expect(response).to have_http_status(:not_found)
    expect(response).not_to be_successful
    expect(response.body).to include("Description can't be blank")
  end
end