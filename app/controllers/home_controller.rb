class HomeController < ApplicationController


  def show
    if user_signed_in?
      @user_langs = current_user.languages
      all_langs = Language.all(sort: [[:price, :asc], [:name, :asc]]).in(hidden: [nil, false])
      @langs = all_langs - @user_langs
    else
      redirect_to :greeting
    end
  end

  def greeting
    if user_signed_in?
      redirect_to :home
    else
      @langs = Language.all.in(hidden: [nil, false]).shuffle.take(3)
    end
  end

end
