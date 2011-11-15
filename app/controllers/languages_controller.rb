class LanguagesController < ApplicationController

  before_filter :ensure_user_authenticated, :only => [:buy]


  def index
    @langs = Language.all(:sort => [[ :_id, :asc]])
  end

  def show
    @lang = Language.find(params[:id])
  end

  def buy
    lang = Language.find(params[:id])
    success = current_user.buy_language(lang)
    render :json => { :success => success }
  end

end
