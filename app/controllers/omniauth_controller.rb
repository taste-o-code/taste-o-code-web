class OmniauthController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => :callback

  def callback
    omniauth = request.env['omniauth.auth']
    user = User.where(:authentications.matches => { :provider => omniauth['provider'], :uid => omniauth['uid'] }).first

    back_url = request.env['omniauth.origin']
    back_url = root_path if back_url.blank? or back_url == new_user_session_url

    if user
      sign_in(:user, user)
      redirect_to back_url, :notice => 'Signed in successfully.'
    elsif user_signed_in?
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
      redirect_to back_url, :notice => 'Authentication successful.'
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        sign_in(:user, user)
        redirect_to back_url, :notice => 'Signed in successfully.'
      else
        msg = "Email #{omniauth['user_info']['email']} is already taken. " +
          "In case it is your account, try to login and add facebook option in settings."
        redirect_to :root, :flash => { :alert => msg }
      end
    end
  end

end