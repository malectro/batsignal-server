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
    @beacon = Beacon.new(params[:beacon])

    if @beacon.save
      render json: @beacon, status: :created, location: @beacon
    else
      render json: @beacon.errors, status: :failed
    end
  end

  def update
    @beacon = Beacon.realize(params[:id])

    if @beacon.update_attributes(params[:beacon])
      render json: @beacon, location: @beacon
    else
      render json: @beacon.errors, status: :failed
    end
  end
end

