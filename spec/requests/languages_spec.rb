require 'spec_helper'

describe LanguagesController do

  describe 'unauthenticated user' do

    it 'should list all languages' do
      languages = (1..5).map { Factory(:language) }

      visit languages_path
      languages.each { |l| page.should have_content(l.name) }
    end

    it 'should display language info' do
      lang = Factory :language

      visit language_path(lang)

      page.should have_content(lang.name)
      page.should have_content(lang.description)
      lang.links.map { |link| page.should have_content(link) }
    end

  end

  describe 'authenticated user' do

    before(:each) do
      @user = create_and_login_user
      @lang = Factory :language, price: 0

      @user.buy_language @lang
      visit language_path(@lang)
    end

    it 'should contains links to tasks' do
      @lang.tasks.map{ |task| page.should have_content(task.name) }
    end

    it 'should navigate to task page' do
      task = @lang.tasks.first

      click_link task.name

      current_path.should eq(language_task_path(@lang, task))
    end

    it 'should highlight solved tasks' do
      task = @lang.tasks.first
      @user.solve_task task
      visit language_path(@lang)

      find('.solved').should have_content(task.name)
    end

    it 'should highlight unsubdued tasks' do
      task = @lang.tasks.first
      @user.fail_task task
      visit language_path(@lang)

      find('.unsubdued').should have_content(task.name)
    end
  end

end
