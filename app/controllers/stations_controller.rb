class StationsController < ApplicationController

  def index
    @stations = Station.last(70)
    @jobs= Job.select(:timestamp).last
  end

end
