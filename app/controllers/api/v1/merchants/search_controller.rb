class Api::V1::Merchants::SearchController < ApplicationController 

  def show 
    if params[:name]
      merchant = Merchant.find_merchant(params[:name])
      if merchant.class == Merchant 
        render json: MerchantSerializer.new(merchant)
      else
        err = SearchError.new("NOT FOUND", "No merchant matches search", 404)
        render json: { errors: SearchErrorSerializer.new(err).serialized_error }, status: :bad_request
      end
    else
      err = SearchError.new("NOT FOUND", "Name query must be entered", 404)
      render json: { errors: SearchErrorSerializer.new(err).serialized_error }, status: :bad_request
    end 
  end
end