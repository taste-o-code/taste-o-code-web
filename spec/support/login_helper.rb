module LoginHelper

  def login_user(user = nil, options = {})
    user ||= create(:user)
    login(user.email, user.password, options[:form])
  end

  def login(email, password, form = nil)
    form ||= find('form#new_user')
    form.fill_in 'user_email', :with => email
    form.fill_in 'user_password', :with => password
    form.click_button 'Login'
  end

  def open_ajax_login_form()
    find('#login_trigger').click
    find('form#login_form')
  end

  def create_and_login_user(options = {})
    create(:user, options).tap do |user|
      visit new_user_session_path
      login_user user
    end
  end

  def should_be_logged_in(user)
    find('#user_bar .name').should have_content(user.name)
  end

  def should_not_be_logged_in
    page.should have_css('#signup')
  end

  def openid_link(provider = :google)
    find("#content a[href='/users/auth/#{provider}']")
  end

end
