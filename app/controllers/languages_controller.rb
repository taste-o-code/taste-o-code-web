class LanguagesController < ApplicationController

  def index
    @langs = Language.all(:sort => [[ :_id, :asc]])
  end

  def show
    @lang = Language.find(params[:id])
  end

end
