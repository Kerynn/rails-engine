require 'rails_helper'

RSpec.describe 'Merchant Search' do 
  before :each do 
    @merchant_1 = create(:merchant, name: "World of Coffee")
    @merchant_2 = create(:merchant, name: "Hello World")
    @merchant_3 = create(:merchant, name: "Ring World")
    @merchant_4 = create(:merchant, name: "Happy Place")
  end

  it 'will return a single object in alphabetical order' do 
    get '/api/v1/merchants/find?name=World'

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data][:id].to_i).to eq(@merchant_2.id)

    expect(merchant).to have_key(:data)
    expect(merchant[:data]).to be_a(Hash)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to eq("merchant")

    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to be_a(Hash)
    
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it 'will return the merchant with a case-insensative search' do 
    get '/api/v1/merchants/find?name=woRLd'

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data][:id].to_i).to eq(@merchant_2.id)
  end

  it 'will return an error message if no query params entered' do 
    get '/api/v1/merchants/find?'

    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to be_an(Array)

    expect(error_response[:errors][0]).to have_key(:status)
    expect(error_response[:errors][0][:status]).to be_a(String)

    expect(error_response[:errors][0]).to have_key(:message)
    expect(error_response[:errors][0][:message]).to be_a(String)
    expect(error_response[:errors][0][:message]).to eq("Name query must be entered")

    expect(error_response[:errors][0]).to have_key(:code)
    expect(error_response[:errors][0][:code]).to be_an(Integer)
    
    get '/api/v1/merchants/find?name='

    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to be_an(Array)

    expect(error_response[:errors][0]).to have_key(:status)
    expect(error_response[:errors][0][:status]).to be_a(String)

    expect(error_response[:errors][0]).to have_key(:message)
    expect(error_response[:errors][0][:message]).to be_a(String)
    expect(error_response[:errors][0][:message]).to eq("Name query must be entered")
    
    expect(error_response[:errors][0]).to have_key(:code)
    expect(error_response[:errors][0][:code]).to be_an(Integer)
  end

  it 'will return an error message if query did not return a merchant result' do 
    get '/api/v1/merchants/find?name=Goodbye'

    # response = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    # expect(response).to have_key(:data)
    # expect(response[:data]).to be_a(Hash)
  end
end