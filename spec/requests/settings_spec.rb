require 'spec_helper'

describe SettingsController do

  context 'settings form' do
    it 'should allow user to change his email' do
      user = create_and_login_user :email => 'old@example.com'
      new_email = 'new@example.com'

      visit settings_path
      fill_in 'Email', :with => new_email
      click_button 'Save'

      user.reload.email.should == new_email
      find_field('user_email').value.should == new_email
    end

    it 'should send confirmation after email change' do
      user = create_and_login_user :email => 'old@example.com'
      new_email = 'new@example.com'

      visit settings_path
      fill_in 'Email', :with => new_email
      click_button 'Save'

      user.reload

      mail = ActionMailer::Base.deliveries.last
      mail.to.should include(new_email)
      mail.body.should include(user.name)
      mail.body.should include(user.confirmation_token)

    end

    it 'should not allow to save empty email' do
      user = create_and_login_user
      email = user.email

      visit settings_path
      fill_in 'Email', :with => ''
      click_button 'Save'

      user.reload.email.should == email
      page.should have_content("Email can't be blank")
    end
  end

  context 'password form' do
    it 'should be displayed for regular user' do
      user = create_and_login_user

      visit settings_path

      page.should have_field('Current password')
      page.should have_field('New password')
      page.should have_field('Repeat password')
    end

    it 'should not be displayed for user who registered via openid' do
      user = Factory :user_with_omniauth_identity
      visit new_user_session_path
      openid_link.click

      visit settings_path

      page.should_not have_field('Current password')
      page.should_not have_field('New password')
      page.should_not have_field('Repeat password')
    end
  end

  context 'password form' do
    before(:each) do
      @old_pass = 'old_pass'
      @new_pass = 'new_pass'
      @user = create_and_login_user :password => @old_pass
    end

    def try_change_password(current, new, confirmation)
      visit settings_path
      fill_in 'Current password', :with => current
      fill_in 'New password', :with => new
      fill_in 'Repeat password', :with => confirmation
      click_button 'Change'
    end

    it 'should allow user to change password' do
      try_change_password @old_pass, @new_pass, @new_pass

      @user.reload.valid_password?(@new_pass).should be_true
    end

    it 'should not accept blank password' do
      try_change_password @old_pass, '', ''

      @user.reload.valid_password?(@old_pass).should be_true
      page.should have_content("Password can't be blank")
    end

    it 'should not change password if the current password is wrong' do
      try_change_password 'wrong_pass', @new_pass, @new_pass

      @user.reload.valid_password?(@old_pass).should be_true
      page.should have_content('Current password is invalid')
    end

    it "should not change password if confirmation doesn't match'" do
      try_change_password @old_pass, @new_pass, 'wrong_pass'

      @user.reload.valid_password?(@old_pass).should be_true
      page.should have_content("Password doesn't match confirmation")
    end
  end

end
