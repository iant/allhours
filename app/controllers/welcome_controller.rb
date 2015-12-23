class WelcomeController < ApplicationController
  def index
    @hours = current_user.hours.all
  end
end
