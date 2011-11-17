module LoginHelper

  def login_user(options = {})
    user = options.fetch(:user) { Factory(:user) }
    login(user.email, user.password, options[:form])
  end

  def login(email, password, form = nil)
    form ||= find('form#user_new')
    form.fill_in 'user_email', :with => email
    form.fill_in 'user_password', :with => password
    form.click_button 'Login'
  end

  def open_ajax_login_form()
    find('#login_trigger').click
    find('form#login_form')
  end

  def create_and_login_user(options = {})
    Factory(:user, options).tap do |user|
      visit new_user_session_path
      login_user :user => user
    end
  end

end