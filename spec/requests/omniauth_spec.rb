require 'spec_helper'

describe OmniauthController, :type => :request do

  it 'should sing in user with google openid' do
    visit new_user_session_path
    find('#content .login-form a[href="/users/auth/google"]').click
    page.should have_content('Signed in successfully.')
  end

end