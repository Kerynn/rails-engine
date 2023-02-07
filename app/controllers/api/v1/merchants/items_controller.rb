class Api::V1::Merchants::ItemsController < ApplicationController
  
  def index
    merchant = Merchant.find(params[:id])
    if merchant.id
      render json: ItemSerializer.new(merchant.items)
    else
      render json: { errors: merchant.errors.full_messages.to_sentence }, status: :not_found
    end 
  end
end