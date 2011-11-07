require 'spec_helper'

describe 'Login process', :type => :request do

  describe 'Login with omniauth' do

    it 'should sing in user with google openid' do
      visit new_user_session_path
      find('#content .login-form a[href="/users/auth/google"]').click
      page.should have_content('Signed in successfully.')
    end

  end

  describe 'Login user with password' do
    it 'should login successfully' do
      simple_login
      page.should have_content('Signed in successfully.')
    end
  end

  describe 'Logout', :js => :true do
    it 'should logout successfully' do
      simple_login
      visit home_path
      find('#user_bar.logged-in .hover-trigger').trigger(:hover)
      click_link 'Logout'
      page.should have_content('Signed out successfully.')
    end
  end


  def simple_login(user = nil)
    user ||= Factory(:user)
    visit new_user_session_path
    form = find('form#user_new')
    form.fill_in 'user_email', :with => user.email
    form.fill_in 'user_password', :with => user.password
    form.click_button 'Login'
  end

end
