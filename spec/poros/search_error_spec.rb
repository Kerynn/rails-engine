require 'rails_helper'

RSpec.describe SearchError do 
  it 'exists and has attributes' do 
    error_details = SearchError.new("NOT FOUND", "Merchant not found", 404)

    expect(error_details).to be_an_instance_of(SearchError)
    expect(error_details.error_message).to eq("Merchant not found")
    expect(error_details.status).to eq("NOT FOUND")
    expect(error_details.code).to eq(404)
  end
end