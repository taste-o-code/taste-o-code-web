class SettingsController < ApplicationController

  before_filter :ensure_user_authenticated

  def show
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      sign_in @user, :bypass => true
      redirect_to({ :action => :show }, :notice => 'Your settings successfully updated.')
    else
      render :action => :show
    end

  end

  def change_password
    @user = User.find(current_user.id)
    if @user.change_password(params[:user])
      sign_in @user, :bypass => true
      redirect_to({ :action => :show }, :notice => 'Your password was changed.')
    else
      logger.info "Fail :("
      render :action => :show
    end
  end

end
