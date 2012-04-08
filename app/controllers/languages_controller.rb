class LanguagesController < ApplicationController

  before_filter :ensure_user_authenticated, :only => :buy

  def show
    @lang = Language.find(params[:id])
    styx_initialize_with :syntax_mode => @lang.syntax_mode, :code => @lang.code_example
  end

  def buy
    lang = Language.find(params[:lang_id])
    success = current_user.buy_language(lang)
    respond_to do |format|
      format.json do
        response = { :success => success }
        if success
          response.merge!({
            tasks_count: lang.tasks.count,
            available_points: current_user.available_points,
            lang: lang.id
          })
        end
        render :json => response
      end
    end
  end

end
