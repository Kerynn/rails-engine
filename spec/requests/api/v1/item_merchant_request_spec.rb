require 'rails_helper'

RSpec.describe 'Item Merchant API' do 
  it 'sends the merchant associated with an item' do 
    merchant_1 = create(:merchant)
    item1_id = create(:item, merchant_id: merchant_1.id).id

    merchant_2 = create(:merchant)
    item2_id = create(:item, merchant_id: merchant_2.id).id

    get "/api/v1/items/#{item1_id}/merchant"

    expect(response).to be_successful

    item_merchant = JSON.parse(response.body, symbolize_names: true)

    expect(item_merchant.count).to eq(1)

    expect(item_merchant).to have_key(:data)
    expect(item_merchant[:data]).to be_a(Hash)

    expect(item_merchant[:data]).to have_key(:id)
    expect(item_merchant[:data][:id]).to be_a(String)
    expect(item_merchant[:data][:id]).to eq(merchant_1.id.to_s)

    expect(item_merchant[:data]).to have_key(:type)
    expect(item_merchant[:data][:type]).to eq("merchant")

    expect(item_merchant[:data]).to have_key(:attributes)
    expect(item_merchant[:data][:attributes]).to be_a(Hash)

    expect(item_merchant[:data][:attributes]).to have_key(:name)
    expect(item_merchant[:data][:attributes][:name]).to be_a(String)
  end

  xit 'returns an error if item not found' do 
    get "/api/v1/items/3/merchant"

    expect(response).to have_http_status(:not_found)
    expect(response).not_to be_successful
    expect(response.body).to include("Item must exist")
  end
end 