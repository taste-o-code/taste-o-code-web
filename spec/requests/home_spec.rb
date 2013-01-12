require 'spec_helper'

describe HomeController do

  context 'Logged in user' do

    before(:each) do
      @user = create_and_login_user
      @lang = create(:language, :price => 0)
      @hidden_lang = create(:language, :price => 2, :hidden => true)
      visit home_path
    end

    it 'should go to lang page after clicking on lang', :js => true do
      find("##{@lang.id}").click

      current_path.should eq(language_path(@lang))
    end

    it 'should not display hidden language' do
      page.should_not have_content(@hidden_lang.name)
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

    it 'should redirect to home from greeting page' do
      visit greeting_path

      current_path.should eq(home_path)
    end
  end

  context 'Not authenticated user' do
    it 'should redirect to greeting page' do
      visit home_path

      current_path.should eq(greeting_path)
    end
  end
end
