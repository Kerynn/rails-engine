require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe 'merchants index' do 
    it 'sends a list of merchants' do 
      create_list(:merchant, 5)

      get '/api/v1/merchants' 

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(5)

      expect(merchants).to have_key(:data)
      expect(merchants[:data]).to be_an(Array)
      
      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq("merchant")

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a(Hash)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    it 'returns an array of data with one or zero merchants found' do 
      get '/api/v1/merchants' 
      
      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(0)

      expect(merchants).to have_key(:data)
      expect(merchants[:data]).to be_an(Array)

      create(:merchant)
      
      get '/api/v1/merchants' 
      
      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(1)

      expect(merchants).to have_key(:data)
      expect(merchants[:data]).to be_an(Array)
    end
  end

  describe 'merchants show' do 
    it 'can show a single merchant by id' do 
      id = create(:merchant).id 

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(merchant).to have_key(:data)
      expect(merchant[:data]).to be_a(Hash)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)
      string_comparison = id.to_s
      expect(merchant[:data][:id]).to eq(string_comparison)

      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data][:type]).to eq("merchant")

      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to be_a(Hash)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
  end
end