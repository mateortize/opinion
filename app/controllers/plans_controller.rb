class PlansController < ApplicationController
  def index
    @plans = Plan.active
  end
end