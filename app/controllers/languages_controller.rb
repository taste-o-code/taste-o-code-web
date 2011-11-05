class LanguagesController < ApplicationController

  def index
    @langs = Language.all
  end

  def show
    @lang = Language.find(params[:id])
  end

end
