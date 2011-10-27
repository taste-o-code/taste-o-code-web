class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.where(:name => params[:id]).first
  end

end
