class Api::V1::Merchants::ItemsController < ApplicationController
  
  def index
    merchant = Merchant.find(params[:id])
    # if merchant.id
    render json: ItemSerializer.new(merchant.items)
    # else
    #   err = SearchError.new("NOT FOUND", "Merchant not found", 404)
    #   render json: { errors: SearchErrorSerializer.new(err).serialized_error }, status: :not_found
    # end 
  end
end