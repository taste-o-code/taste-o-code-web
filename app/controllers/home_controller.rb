class HomeController < ApplicationController

  def show
    @users = User.all
  end

end
