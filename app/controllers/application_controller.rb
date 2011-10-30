class ApplicationController < ActionController::Base

  protect_from_forgery

  protected

  def ensure_user_authenticated
    redirect_to :root unless user_signed_in?
  end

end
