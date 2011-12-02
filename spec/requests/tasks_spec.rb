require 'spec_helper'

describe TasksController do

  before(:each) do
    @user = create_and_login_user
    @lang = Factory :language, price: 0
    @task = @lang.tasks.first

    @user.buy_language @lang
    visit url_for(@lang)
  end

  it 'should contain link to language page' do
    click_link @lang.name

    current_path.should eq(url_for @lang)
  end

end
