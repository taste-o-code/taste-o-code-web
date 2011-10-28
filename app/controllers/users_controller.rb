class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.where(:name => params[:id]).first
  end

  def edit
    @user = User.where(:name => params[:id]).first
    # Forbid to edit other users.
    unless user_signed_in? and @user == current_user
      redirect_to :root
    end
  end

  def update
    @user = User.where(:name => params[:id]).first
    if @user.update_attributes(params[:user])
      redirect_to user_path(@user)
    else
      render :action => 'edit'
    end
  end

end
