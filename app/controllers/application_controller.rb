class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :set_cache_buster

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end


  protected

  def ensure_user_authenticated
    redirect_to :root unless user_signed_in?
  end

  def notification(type, title, text, options = {})
    notification = { :value => text, :title => title }
    notification.merge! options
    { type => notification }
  end

end
