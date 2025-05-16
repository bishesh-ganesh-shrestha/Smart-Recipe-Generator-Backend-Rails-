class PantriesController < ApplicationController
  before_action :authenticate_user!, except: []

  def show
    render json: { status: 200, pantry: { ingredients: current_user.pantry.ingredients } }
  end
end
