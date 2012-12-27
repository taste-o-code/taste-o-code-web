module ApplicationHelper

  NAVIGATION_ITEMS = {
      'home'      => { :controller => :'/home',  :action => :show },
      'users'     => { :controller => :'/users', :action => :index },
      'about'     => { :controller => :'/about', :action => :show },
  }

  MARKDOWN = Redcarpet::Markdown.new(Redcarpet::Render::HTML)


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
    alt = submission.testing? ? 'Testing' : submission.result.to_s.humanize
    title = submission.failed? ? submission.fail_cause : alt
    image = submission.testing? ? 'loader.gif' : "#{submission.result}.png"
    image_tag(image, alt: alt, title: title)
  end

  def gravatar(user, size, alt = 'Avatar')
    hash = Digest::MD5.hexdigest(user.email.to_s.strip.downcase)
    url = "http://www.gravatar.com/avatar/#{hash}?s=#{size}"
    image_tag url, size: "#{size}x#{size}", alt: alt
  end

  def task_style(task)
    if not user_signed_in?
      'not-tried'
    elsif current_user.solved_task_ids.include? task.id
      'solved'
    elsif current_user.unsubdued_task_ids.include? task.id
      'unsubdued'
    else
      'not-tried'
    end
  end

  def no_access_message(lang)
    user_signed_in? ? "Buy #{lang.name} to submit your solution." :  "Sign in and buy #{lang.name} to submit your solution."
  end

  def markdown(source)
    MARKDOWN.render(source).html_safe
  end

end
