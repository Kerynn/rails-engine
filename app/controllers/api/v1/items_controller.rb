class Api::V1::ItemsController < ApplicationController 

  def index 
    render json: ItemSerializer.new(Item.all)
  end

  def show 
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create 
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else  
      render json: { erros: "Missing attribute or attribute not allowed" }, status: :not_found
    end 
  end

  def update 
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy 
    render json: Item.destroy(params[:id])
  end

  private 

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end