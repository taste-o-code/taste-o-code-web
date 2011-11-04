class OmniauthAuthenticationsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create]

  def create
    omniauth = request.env["omniauth.auth"]
    user = User.where(:authentications.matches => {:provider => omniauth['provider'],
                                                   :uid => omniauth['uid']}).first

    if user
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, user)
    elsif user_signed_in?
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to :root
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        msg = "Email #{omniauth['user_info']['email']} is already taken. " +
          "In case it is your account, try to login and add facebook option in settings."
        redirect_to :root, :flash => {:alert => msg}
      end
    end
  end
end
