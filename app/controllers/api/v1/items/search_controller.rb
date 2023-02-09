class Api::V1::Items::SearchController < ApplicationController 

  def index 
    if params[:name] && (params[:min_price] || params[:max_price])
      err = SearchError.new("NOT FOUND", "Cannot query name and price", 400)
      render json: { errors: SearchErrorSerializer.new(err).serialized_error }, status: :bad_request   
    elsif params[:name]
      name_items = Item.find_all_items_name(params[:name])
      if name_items != nil
        render json: ItemSerializer.new(name_items) 
      else 
        err = SearchError.new("NOT FOUND", "Query must be entered", 400)
        render json: { errors: SearchErrorSerializer.new(err).serialized_error }, status: :bad_request
      end 
    elsif params[:min_price] && params[:max_price]
      min_items = Item.find_all_items_min_price(params[:min_price].to_f)
      max_items = Item.find_all_items_max_price(params[:max_price].to_f)
      all_items = min_items + max_items
      render json: ItemSerializer.new(all_items)
    elsif params[:min_price]
       min_items = Item.find_all_items_min_price(params[:min_price].to_f)
       render json: ItemSerializer.new(min_items)
    elsif params[:max_price] 
      max_items = Item.find_all_items_max_price(params[:max_price].to_f)
      render json: ItemSerializer.new(max_items)
    else 
      err = SearchError.new("NOT FOUND", "Query must be entered", 400)
      render json: { errors: SearchErrorSerializer.new(err).serialized_error }, status: :bad_request   
    end
  end

  private 

  def name_items 
    Item.find_all_items_name(params[:name])
  end

  def min_items
    Item.find_all_items_min_price(params[:min_price].to_f)
  end

  def max_items 
    Item.find_all_items_max_price(params[:max_price].to_f)
  end
end
