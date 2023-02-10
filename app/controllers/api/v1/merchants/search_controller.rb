class Api::V1::Merchants::SearchController < ApplicationController 

  def show 
    if params[:name]
      merchant = Merchant.find_merchant(params[:name])
      if merchant.class == Merchant 
        render json: MerchantSerializer.new(merchant)
      elsif params[:name] == ""
        render json: { errors: SearchErrorSerializer.new(no_query).serialized_error }, status: :bad_request
      else   
        render json: NoDataSerializer.no_data
      end
    else
      render json: { errors: SearchErrorSerializer.new(no_query).serialized_error }, status: :bad_request
    end 
  end
end

private 

def no_query 
  err = SearchError.new("NOT FOUND", "Name query must be entered", 400)
end
