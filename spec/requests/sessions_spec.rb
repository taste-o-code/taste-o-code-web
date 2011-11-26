require 'spec_helper'

describe SessionsController do

  context 'login from login page' do
    it 'should login user with correct email and password' do
      visit new_user_session_path
      login_user

      current_path.should == root_path
      page.should have_flash(:notice, 'Signed in successfully.')
    end

    it 'should not login user with incorrect password' do
      user = Factory :user, :password => '123456'

      visit new_user_session_path
      login user.email, '654321'

      current_path.should == new_user_session_path
      page.should have_flash(:alert, 'Invalid email or password.')
    end

    it 'should not login user with incorrect email' do
      visit new_user_session_path
      login 'correct@example.com', '123456'

      current_path.should == new_user_session_path
      page.should have_flash(:alert, 'Invalid email or password.')
    end

    it 'should reject logged in user redirecting him to root' do
      visit new_user_session_path
      login_user

      visit new_user_session_path

      current_path.should == root_path
      page.should have_flash(:alert, 'You are already signed in.')
    end
  end

  context 'login from ajax form in header', :js => true do
    it 'should login user with correct email and password and reload current page' do
      user = Factory :user, :name => 'Donald Duck'

      visit about_path

      form = open_ajax_login_form
      form.should be_visible

      login_user user, :form => form
      page.should have_content('Reloading')

      current_path.should == about_path
      find('#user_bar .name').should have_content('Donald Duck')
    end

    it 'should not login user with incorrect password' do
      user = Factory :user, :password => '123456'
      visit root_path
      login user.email, '654321', open_ajax_login_form

      page.should have_content('Invalid email or password.')
    end

    it 'should now login user with incorrect email' do
      visit root_path
      login 'correct@example.com', '123456', open_ajax_login_form

      page.should have_content('Invalid email or password.')
    end
  end

  context 'logout from user menu' do
    it 'should logout user', :js => true do
      visit new_user_session_path
      login_user

      visit home_path
      find('#user_trigger').trigger(:hover)
      click_link 'Logout'

      current_path.should == root_path
      page.should have_flash(:notice, 'Signed out successfully.')
    end
  end

end
