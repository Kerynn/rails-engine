class Api::V1::Merchants::ItemsController < ApplicationController

  def index
    begin 
      merchant = Merchant.find(params[:id])
      render json: ItemSerializer.new(merchant.items)  
    rescue ActiveRecord::RecordNotFound
      err = SearchError.new("NOT FOUND", "Merchant must exist", 404)
      render json: { errors: SearchErrorSerializer.new(err).serialized_error }, status: :not_found
    end 
  end
end