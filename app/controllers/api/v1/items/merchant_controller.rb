class Api::V1::Items::MerchantController < ApplicationController

  def show 
    item = Item.find(params[:id])
    # if item.id
    render json: MerchantSerializer.new(item.merchant)
    # else 
    #   render json: { errors: item.errors.full_messages.to_sentence }, status: :not_found
    # end
  end
end