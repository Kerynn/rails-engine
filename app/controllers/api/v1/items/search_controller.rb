class Api::V1::Items::SearchController < ApplicationController 

  def index 
    if params[:name]
      items = Item.find_all_items_search(params[:name])
      if items != nil
        render json: ItemSerializer.new(items) 
      else 
        err = SearchError.new("NOT FOUND", "Query must be entered", 400)
        render json: { errors: SearchErrorSerializer.new(err).serialized_error }, status: :bad_request
      end 
    else 
      err = SearchError.new("NOT FOUND", "Query must be entered", 400)
      render json: { errors: SearchErrorSerializer.new(err).serialized_error }, status: :bad_request   
    end
  end
end
