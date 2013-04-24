class SignalsController < ApplicationController
  def index
    @signals = Signal.all

    render json: @signals, status: :ok
  end

  def create
    @signal = Signal.new(params[:signal])

    if @signal.save
      render json: @signal, status: :created, location: @signal
    else
      render json: @signal.errors, status: :failed
    end
  end
end

