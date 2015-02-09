class MapController < ApplicationController
  def index
    @stations = Station.all
  end
end
