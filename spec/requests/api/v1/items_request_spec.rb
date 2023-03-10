require 'rails_helper'

RSpec.describe 'Items API' do
  describe "items index" do 
    it 'sends a list of items' do 
      create_list(:item, 6)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(6)
      
      expect(items).to have_key(:data)
      expect(items[:data]).to be_an(Array)

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

    it 'returns an array of data with one or zero items found' do 
      get '/api/v1/items' 
      
      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(0)

      expect(items).to have_key(:data)
      expect(items[:data]).to be_an(Array)

      create(:item)
      
      get '/api/v1/items' 
      
      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(1)

      expect(items).to have_key(:data)
      expect(items[:data]).to be_an(Array)
    end
  end

  describe 'items show' do 
    it 'can show an item by its id' do 
      id = create(:item).id 

      get "/api/v1/items/#{id}"

      item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(item).to have_key(:data)
      expect(item[:data]).to be_a(Hash)

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_a(String)
      string_comparison = id.to_s
      expect(item[:data][:id]).to eq(string_comparison)

      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to eq("item")

      expect(item[:data]).to have_key(:attributes)
      expect(item[:data][:attributes]).to be_a(Hash)

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)

      expect(item[:data][:attributes]).to_not have_key(:merchant_id)
    end
  end

  describe 'item create' do 
    it 'can create a new item' do
      merchant_id = create(:merchant).id
      item_params = ({
                      name: 'Hair Bender',
                      description: 'Dark Roast, whole beans',
                      unit_price: 8.99,
                      merchant_id: merchant_id
                    })
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last 

      created_item_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response).to have_http_status(:created)
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])

      expect(created_item_response).to have_key(:data)
      expect(created_item_response[:data]).to be_a(Hash)

      expect(created_item_response[:data]).to have_key(:id)
      expect(created_item_response[:data][:id]).to be_a(String)

      expect(created_item_response[:data]).to have_key(:type)
      expect(created_item_response[:data][:type]).to eq("item")

      expect(created_item_response[:data]).to have_key(:attributes)
      expect(created_item_response[:data][:attributes]).to be_a(Hash)

      expect(created_item_response[:data][:attributes]).to have_key(:name)
      expect(created_item_response[:data][:attributes][:name]).to be_a(String)

      expect(created_item_response[:data][:attributes]).to have_key(:description)
      expect(created_item_response[:data][:attributes][:description]).to be_a(String)
      
      expect(created_item_response[:data][:attributes]).to have_key(:unit_price)
      expect(created_item_response[:data][:attributes][:unit_price]).to be_a(Float)
      
      expect(created_item_response[:data][:attributes]).to have_key(:merchant_id)
      expect(created_item_response[:data][:attributes][:merchant_id]).to be_an(Integer)
    end

    it 'will return an error if missing an attribute' do 
      merchant_id = create(:merchant).id
      item_params = ({
                      name: 'Hair Bender',
                      unit_price: 8.99,
                      merchant_id: merchant_id
                    })
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      
      expect(response).to have_http_status(:not_found)
      expect(response).not_to be_successful
      expect(response.body).to include("Description can't be blank")
    end

    it 'will ignore attributes not allowed' do 
      item_params = ({
                      name: 'Hair Bender',
                      description: 'Dark Roast, whole beans',
                      unit_price: "happy",
                      merchant_id: 10
                    })
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to have_http_status(:not_found)
      expect(response).not_to be_successful
      expect(response.body).to include("Merchant must exist and Unit price is not a number") 
    end
  end

  describe 'item update' do 
    it 'can update an existing item' do 
      id = create(:item).id 
      previous_name = Item.last.name 
      
      item_params = { name: "Mountain Fresh" }
      headers = { "CONTENT_TYPE" => "application/json" }

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(response).to have_http_status(:created)
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq("Mountain Fresh")
    end

    it 'will return error if unable to update an item' do 
      id = create(:item).id 
      previous_name = Item.last.name 
      
      item_params = { merchant_id: 10 }
      headers = { "CONTENT_TYPE" => "application/json" }

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

      expect(response).to have_http_status(:not_found)
      expect(response).not_to be_successful
      expect(response.body).to include("Merchant must exist") 
    end
  end

  describe 'item destroy' do 
    it 'can destroy an item' do 
      item = create(:item)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(response).to have_http_status(:no_content)
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

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

      delete "/api/v1/items/#{item1.id}"

      expect(Item.count).to eq(1)
      expect(Invoice.count).to eq(1)
      expect(InvoiceItem.count).to eq(1)

      expect(response).to be_successful
      expect(response).to have_http_status(:no_content)
      expect{Item.find(item1.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{Invoice.find(invoice1.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{InvoiceItem.find(ii_1.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{InvoiceItem.find(ii_2.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end 
