class HomeController < ApplicationController


  def show
    if user_signed_in?
      @user_langs = current_user.languages
      @langs = Language.all(sort: [[:price, :asc], [:name, :asc]]) - @user_langs
    else
      redirect_to :greeting
    end
  end

  def greeting
    if user_signed_in?
      redirect_to :home
    else
      @langs = Language.all(sort: [[:name, :asc]]).take(3)
      langs_json = @langs.map { |lang| { syntax_mode: lang.syntax_mode, code: lang.code_example, name: lang.id } }
      styx_initialize_with langs: langs_json
    end
  end

end
