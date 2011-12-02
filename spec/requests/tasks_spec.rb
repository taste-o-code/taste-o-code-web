require 'spec_helper'

describe TasksController do

  before(:each) do
    @lang = Factory :language, price: 0
    @task = @lang.tasks.first
    @url = language_task_path @lang, @task
  end

  context 'user with access to task' do

    before(:each) do
      @user = create_and_login_user
      @user.buy_language @lang
      visit @url
    end

    it 'should contain link to language page' do
      click_link @lang.name

      current_path.should eq(language_path @lang)
    end
  end

  context 'user without access to task' do

    it 'should not show task for unauthenticated user' do
      visit @url

      current_path.should_not eq(@url)
    end

    it "should not show task for user, who didn't buy language" do
      create_and_login_user

      visit @url

      current_path.should_not eq(@url)
    end
  end

end
