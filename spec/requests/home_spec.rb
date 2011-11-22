require 'spec_helper'

describe HomeController, :type => :request do

  include LoginHelper

  before(:each) do
    @user = create_and_login_user
    @lang = Factory :language, :price => 0
    visit home_path
  end

  it 'should go to lang page after clicking on lang', :js => true do
    find("##{@lang.id}").click

    current_path.should == language_path(@lang)
  end

  it 'should buy language', :js => true do
    find("##{@lang.id} .buy").click
    wait_until { find('#buy_button').visible? }
    find("#buy_button").click
    visit home_path
    find("#purchased_langs ##{@lang.id}").should be_present
    @user.reload.has_language?(@lang).should be_true
  end


end
