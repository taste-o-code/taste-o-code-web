require 'spec_helper'

describe OmniauthController do

  context 'if user is not logged in' do
    it 'should create new account and sign in user if openid identity is not used by any existing user' do
      lambda do
        visit new_user_session_path
        openid_link.click
      end.should change(User, :count).from(0).to(1)

      user = User.first
      user.omniauth_identities.size.should == 1
      should_be_logged_in user
    end

    it 'should sign in existing user' do
      user = Factory :user_with_omniauth_identity

      lambda do
        visit new_user_session_path
        openid_link.click
      end.should_not change(User, :count)

      should_be_logged_in user
    end

    it 'should not allow openid identity with email that is already associated with a different account' do
      email = OmniAuth.config.mock_auth[:google]['info']['email']
      first_user = Factory :user, :email => email

      lambda do
        visit new_user_session_path
        openid_link.click
      end.should_not change(User, :count)

      current_path.should == new_user_session_path
      should_not_be_logged_in
    end
  end

  context 'if user is logged in' do
    it 'should add new openid identity to the account' do
      user = create_and_login_user

      lambda do
        visit settings_path
        openid_link.click
      end.should change{ user.reload.omniauth_identities.size }.from(0).to(1)

      find('#user_bar .name').should have_content(user.name)
    end

    it "should not add identity if it's already attached to a different account" do
      first_user = Factory :user_with_omniauth_identity, :name => 'First'

      second_user = create_and_login_user :name => 'Second'

      visit settings_path
      openid_link.click

      second_user.reload.omniauth_identities.size.should == 0
      should_be_logged_in second_user
    end
  end

end
