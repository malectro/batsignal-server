class HomeController < ApplicationController
  skip_before_filter :require_session, only: [:index]

  def index

  end
end
