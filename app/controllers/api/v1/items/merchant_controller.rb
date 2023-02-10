class Api::V1::Items::MerchantController < ApplicationController

  def show
    begin 
      item = Item.find(params[:id])
      render json: MerchantSerializer.new(item.merchant)
    rescue ActiveRecord::RecordNotFound
      err = SearchError.new("NOT FOUND", "Item must exist", 404)
      render json: { errors: SearchErrorSerializer.new(err).serialized_error }, status: :not_found
    end
  end
end