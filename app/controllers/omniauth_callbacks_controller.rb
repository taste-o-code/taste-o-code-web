class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    data = env['omniauth.auth']['extra']['user_hash']
    @user = User.find_for_facebook_oauth(data, current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      msg = "Email #{data['email']} is already taken. " +
        "In case it is your account, try to login and add facebook option in settings."
      redirect_to :root, :flash => {:alert => msg}
    end
  end
end
