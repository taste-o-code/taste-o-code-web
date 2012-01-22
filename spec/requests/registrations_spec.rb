require 'spec_helper'

describe Devise::RegistrationsController do

  it 'should send confirmation email' do
    user = Factory.build :user

    visit new_user_registration_path

    form = find('form#new_user')
    form.fill_in 'user_name', :with => user.name
    form.fill_in 'user_email', :with => user.email
    form.fill_in 'user_password', :with => '123456'
    form.fill_in 'user_password_confirmation', :with => '123456'

    form.click_button 'Sign up'

    user = User.first

    mail = ActionMailer::Base.deliveries.last
    mail.to.should include(user.email)
    mail.body.should include(user.name)
    mail.body.should include(user.confirmation_token)
  end
end
