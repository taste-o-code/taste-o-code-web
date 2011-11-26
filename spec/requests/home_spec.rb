require 'spec_helper'

describe HomeController do

  before(:each) do
    @user = create_and_login_user
    @lang = Factory :language, :price => 0

    visit home_path
  end

  it 'should go to lang page after clicking on lang', :js => true do
    find("##{@lang.id}").click

    current_path.should eq(language_path(@lang))
  end

  it 'should buy language', :js => true do
    find("##{@lang.id} .buy").click

    # find('#buy_dialog').visible? doesn't work here as it ignores 'visibility' css-style
    wait_until { find('#buy_dialog').has_content?(@lang.name) }
    find('#buy_button').click

    visit home_path

    @user.reload.has_language?(@lang).should be_true
    page.should have_selector("#purchased_langs ##{@lang.id}")
  end

end
