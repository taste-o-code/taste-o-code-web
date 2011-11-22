class SettingsController < ApplicationController

  before_filter :ensure_user_authenticated

  def show
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    method, success_message = update_method_and_message params[:user]
    if @user.send(method, params[:user])
      sign_in @user, :bypass => true
      redirect_to settings_path, :notice => success_message
    else
      render :action => :show
    end
  end

  protected

  def update_method_and_message(params)
    if params.has_key?(:password)
      [:change_password, 'Your password was successfully changed.']
    else
      [:update_attributes, 'Your settings were successfully updated.']
    end
  end

end
