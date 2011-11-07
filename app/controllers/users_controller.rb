class UsersController < ApplicationController

  before_filter :ensure_user_authenticated, :except => [:show, :index]
  before_filter :check_edit_permission, :only => [:edit, :update]

  def index
    @users = User.all
  end

  def show
    unless @user = User.first(:conditions => { :id => params[:id].to_i })
      redirect_to({ :action => :index }, :alert => "There is no user with id #{params[:id]}.")
    end
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Your profile successfully updated.'
      render :action => :show
    else
      render :action => :edit
    end
  end

  protected

  def check_edit_permission
    if params[:id] == current_user.id.to_s
      @user = current_user
    else
      redirect_to({ :action => :show, :id => params[:id] }, :alert => 'You can edit only your own profile.')
    end
  end

end
