require 'spec_helper'

describe OmniauthController, :type => :request do

  include LoginHelper

  context 'if user is not logged in' do
    it 'should sing in user with google openid' do
      visit new_user_session_path
      find('#content a[href="/users/auth/google"]').click

      page.should have_content('Signed in successfully.')
    end
  end

  context 'if user is logged in' do
    it 'should add new openid identity to the account' do
      user = create_and_login_user

      visit settings_path
      find('#content a[href="/users/auth/google"]').click

      find('#user_bar .name').should have_content(user.name)
      page.should have_flash(:notice, 'Successfully added openid identity.')
    end

    it "should not add identity if it's already attached to a different account" do
      authentication = Authentication.new :provider => 'google', :uid => OmniAuth.config.mock_auth[:google]['uid']
      winner = Factory :user, :name => 'Winner', :authentications => [authentication]

      loser = create_and_login_user :name => 'Loser'

      visit settings_path
      find('#content a[href="/users/auth/google"]').click

      find('#user_bar .name').should have_content('Loser')
      page.should have_flash(:alert, 'This openid identity is already attached to a different account.')
    end
  end

end