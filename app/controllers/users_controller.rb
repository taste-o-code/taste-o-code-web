class UsersController < ApplicationController

  before_filter :ensure_user_authenticated, :except => [:show, :index]
  before_filter :check_edit_permission, :only => [:edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id].to_i
  end

  def update
    if @user.update_attributes(params[:user])
      @user.clear_progress
      redirect_to @user, :notice => 'Your profile successfully updated.'
    else
      render :action => :edit
    end
  end

  protected

  def check_edit_permission
    if params[:id] == current_user.id.to_s
      @user = User.find(current_user.id)
    else
      redirect_to user_path(params[:id]), :alert => 'You can edit only your own profile.'
    end
  end

end
