class OmniauthController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => :callback

  def callback
    omniauth = request.env['omniauth.auth']
    user = User.where(:omniauth_identities.matches => { :provider => omniauth['provider'], :uid => omniauth['uid'] }).first

    if user_signed_in?
      unless user
        add_identity_to_user omniauth
      else
        redirect_to back_url, :gflash => notification(:error, 'Identity already in use', "This #{omniauth['provider']} identity is already attached to a different account.", :sticky => true)
      end
    else
      if user
        sign_in(:user, user)
        redirect_to back_url
      else
        create_user omniauth
      end
    end
  end

  private

  def back_url()
    back_url = request.env['omniauth.origin']
    if  back_url.blank? or back_url == new_user_session_url
      root_path
    else
      back_url
    end
  end

  def create_user(omniauth)
    user = User.new
    user.apply_omniauth(omniauth)
    user.skip_confirmation!
    if user.save
      sign_in(:user, user)
      redirect_to back_url, :gflash => notification(:success, 'Congratulations!', 'Successfully created new account.')
    else
      msg = "Email #{omniauth['info']['email']} is already taken.
                 In case it is your account, try to login and add #{omniauth['provider']} login in settings."
      redirect_to new_user_session_path, :gflash => notification(:error, 'Email already in use', msg, :sticky => true)
    end
  end


  def add_identity_to_user(omniauth)
    current_user.omniauth_identities.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
    redirect_to back_url, :gflash => notification(:success, 'Identity added', "Successfully added #{omniauth['provider']} identity.")
  end

end
