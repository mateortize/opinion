class PlansController < ApplicationController
  def index
    @plans = Plan.active.order("position asc")
  end
end