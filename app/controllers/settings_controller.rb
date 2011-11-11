class SettingsController < ApplicationController

  before_filter :ensure_user_authenticated

  def show
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    method, message = params[:user].has_key?(:password) ?
                      [:change_password, 'Your password was changed.'] :
                      [:update_attributes, 'Your settings successfully updated.']
    if @user.send(method, params[:user])
      sign_in @user, :bypass => true
      redirect_to({ :action => :show }, :notice => message)
    else
      render :action => :show
    end
  end

end
