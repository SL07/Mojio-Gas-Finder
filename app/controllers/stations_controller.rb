class StationsController < ApplicationController
  before_action :set_station, only: [:show, :edit, :update, :destroy]

  # GET /stations
  # GET /stations.json
  def index
    @stations = Station.last(70)
    @jobs= Job.select("timestamp").last
  end

  # GET /stations/new
  def new
  end
end
