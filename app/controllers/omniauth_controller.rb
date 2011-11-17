class OmniauthController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => :callback

  def callback
    omniauth = request.env['omniauth.auth']
    user = User.where(:authentications.matches => { :provider => omniauth['provider'], :uid => omniauth['uid'] }).first

    back_url = request.env['omniauth.origin']
    back_url = root_path if back_url.blank? or back_url == new_user_session_url

    if user_signed_in?
      unless user
        current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
        redirect_to back_url, :notice => 'Successfully added openid identity.'
      else
        redirect_to back_url, :alert => 'This openid identity is already attached to a different account.'
      end
    else
      if user
        sign_in(:user, user)
        redirect_to back_url, :notice => 'Signed in successfully.'
      else
        user = User.new
        user.apply_omniauth(omniauth)
        if user.save
          sign_in(:user, user)
          redirect_to back_url, :notice => 'Signed in successfully.'
        else
          msg = "Email #{omniauth['user_info']['email']} is already taken.
                 In case it is your account, try to login and add #{omniauth['provider']} login in settings."
          redirect_to :root, :flash => { :alert => msg }
        end
      end
    end
  end

end
