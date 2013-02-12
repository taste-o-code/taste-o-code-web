class UsersController < ApplicationController

  USERS_PER_PAGE = 10

  before_filter :ensure_user_authenticated, :except => [:show, :index]
  before_filter :check_edit_permission, :only => [:edit, :update]

  def index
    @users = User.all(sort: [[:total_points, :desc]])
                 .in(hidden: [nil, false])
                 .page(params[:page])
                 .per(USERS_PER_PAGE)
  end

  def show
    @user = User.find params[:id].to_i
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render :action => :edit
    end
  end

  protected

  def check_edit_permission
    if params[:id] == current_user.id.to_s
      Mongoid::IdentityMap.clear # for @user to be an independent copy of current_user
      @user = User.find(current_user.id)
    else
      redirect_to user_path(params[:id]), :gflash => notification(:error, "Don't cheat!", 'You can edit only your own profile.')
    end
  end

end
