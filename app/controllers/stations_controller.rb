class StationsController < ApplicationController
  before_action :set_station, only: [:show, :edit, :update, :destroy]

  # GET /stations
  # GET /stations.json
  def index
    @stations = Station.all
    @jobs= Job.select("timestamp").first
  end

  # GET /stations/new
  def new
  end
end
