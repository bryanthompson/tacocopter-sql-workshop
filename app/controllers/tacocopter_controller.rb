class TacocopterController < ApplicationController

  def index
    @tacos  = Taco.all.order("name asc")
    @salsas = Salsa.all.order("name asc")
  end

  def search
    @stores = Store.find_stores_with_taco_and_salsas(
      params[:selected_taco_ids],
      params[:selected_salsa_ids]
    )
  end

end
