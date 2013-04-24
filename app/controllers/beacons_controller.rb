class BeaconsController < ApplicationController
  def index
    @beacons = Beacon.all
    render json: @beacons, status: :ok
  end

  def show
    @beacon = Beacon.find(params[:id])
    render json: @beacon, status: :ok
  end

  def create
    @beacon = Beacon.new(params[:signal])

    if @beacon.save
      render json: @beacon, status: :created, location: @beacon
    else
      render json: @beacon.errors, status: :failed
    end
  end
end

