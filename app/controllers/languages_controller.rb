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
    respond_to do |format|
      format.json do
        response = { :success => success }
        response.merge!({tasks_count: lang.tasks.count,
                         available_points: current_user.available_points,
                         lang: lang.id}) if success
        render :json => response
      end
    end
  end

end
