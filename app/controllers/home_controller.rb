class HomeController < ApplicationController

  def show
    @langs = Language.all(sort: [[:price, :asc], [:name, :asc]])
    if user_signed_in?
      @user_langs = current_user.languages
      @langs -= @user_langs
    end
  end

end
