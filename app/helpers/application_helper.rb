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
    image_tag("#{submission.result}.#{submission.testing? ? 'gif' : 'png'}")
  end

  def task_style(task)
    if current_user.solved_task_ids.include? task.id
      'solved'
    elsif current_user.unsubdued_task_ids.include? task.id
      'unsubdued'
    else
      'not-tried'
    end
  end

  def markdown(source)
    MARKDOWN.render(source).html_safe
  end

end
