require 'spec_helper'

describe UsersController do

  it 'should lists all users except hidden' do
    users = (1..5).map { create(:user) }
    hidden_user = create(:user, :hidden => true)

    visit users_path

    users.each do |u|
      page.should have_content(u.name)
    end
    page.should_not have_content(hidden_user.name)
  end

  context 'profile page' do
    it "should display user info" do
      user = create(:user)

      visit user_path(user)

      [:name, :location, :about].each { |field| page.should have_content(user[field]) }
      page.should have_selector("#content img[alt$='Avatar']")
    end

    it 'should allow user to edit his profile' do
      user = create_and_login_user
      visit user_path(user)

      page.should have_link('edit')
      click_link 'edit'
      current_path.should == edit_user_path(user)
    end

    it "should not allow user to edit somebody else's profile" do
      owner = create(:user, :name => 'owner')
      create_and_login_user

      visit user_path(owner)

      page.should_not have_link('edit')

      visit edit_user_path(owner)

      current_path.should == user_path(owner)
    end
  end

  context 'edit profile page' do
    it 'should allow user to update his info' do
      user = create_and_login_user
      new_info = [:name, :location, :about].map.inject({}) { |m, f| m.merge f => "New #{f}" }

      visit edit_user_path(user)
      new_info.each { |field, value| fill_in field.to_s.humanize, :with => value }
      click_button 'Save'

      current_path.should == user_path(user)
      user = user.reload
      new_info.each do |field, value|
        user[field].should == value
        page.should have_content(value)
      end
      find('#user_bar').should have_content(new_info[:name])
    end

    it 'should not allow blank name' do
      user = create_and_login_user
      user_name = user.name

      visit edit_user_path(user)

      fill_in 'Name', :with => ''
      click_button 'Save'

      page.should have_content("Name can't be blank")
      find('#user_bar').should have_content(user_name)
    end
  end

end
