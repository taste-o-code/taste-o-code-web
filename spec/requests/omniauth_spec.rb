require 'spec_helper'

describe OmniauthController, :type => :request do

  include LoginHelper

  context 'if user is not logged in' do
    it 'should create new account and sign in user' do
      visit new_user_session_path
      find('#content a[href="/users/auth/google"]').click

      page.should have_content('Successfully created new account.')
    end

    it 'should sign in existing user' do
      user = Factory :user_with_omniauth_identity

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
      first_user = Factory :user_with_omniauth_identity, :name => 'First'

      second_user = create_and_login_user :name => 'Second'

      visit settings_path
      find('#content a[href="/users/auth/google"]').click

      find('#user_bar .name').should have_content('Second')
      page.should have_flash(:alert, 'This openid identity is already attached to a different account.')
    end
  end

end
