module ApplicationHelper

  NAVIGATION_ITEMS = {
      'home'      => { :controller => '/home',      :action => :show },
      'users'     => { :controller => '/users',     :action => :index },
      'languages' => { :controller => '/languages', :action => :index },
      'about'     => { :controller => '/about',     :action => :show },
  }


  def navigation
    render :partial => 'layouts/navigation'
  end

  def navigation_items
    NAVIGATION_ITEMS
  end

  def auth_providers_links(icons_size = 64)
    render :partial => '/layouts/auth_providers_links', :locals => { :icons_size => icons_size }
  end

  def error_message(model, field)
    unless model.errors[field].blank?
      message = "#{field.to_s.humanize} #{model.errors[field].first}"
      content_tag('div', message, :class => 'field-error')
    end
  end

  def submission_image(submission)
    ext = submission.result == :testing ? 'gif' : 'png'
    image_tag("#{submission.result}.#{ext}")
  end

end
