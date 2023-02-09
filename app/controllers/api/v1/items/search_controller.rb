class Api::V1::Items::SearchController < ApplicationController 

  def index 
    if params[:name] && (params[:min_price] || params[:max_price])
      render json: { errors: SearchErrorSerializer.new(name_and_price_query).serialized_error }, status: :bad_request   
    elsif params[:name]
      if name_items != nil
        render json: ItemSerializer.new(name_items) 
      else 
        render json: { errors: SearchErrorSerializer.new(no_query).serialized_error }, status: :bad_request
      end 
    elsif params[:min_price] && params[:max_price]
        render json: ItemSerializer.new(all_items) 
    elsif params[:min_price]
      if params[:min_price].to_f >= 0
        render json: ItemSerializer.new(min_items)
      else 
        render json: { errors: SearchErrorSerializer.new(negative_query).serialized_error }, status: :bad_request   
      end
    elsif params[:max_price] 
      if params[:max_price].to_f >= 0
        render json: ItemSerializer.new(max_items) 
      else 
        render json: { errors: SearchErrorSerializer.new(negative_query).serialized_error }, status: :bad_request   
      end
    else 
      render json: { errors: SearchErrorSerializer.new(no_query).serialized_error }, status: :bad_request   
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

  def all_items
    min_items + max_items
  end

  def no_query 
    SearchError.new("NOT FOUND", "Query must be entered", 400)
  end

  def name_and_price_query 
    SearchError.new("NOT FOUND", "Cannot query name and price", 400)
  end

  def negative_query 
    SearchError.new("NOT FOUND", "Price query cannot be a negative number", 400)
  end
end
