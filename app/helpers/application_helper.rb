module ApplicationHelper

  NAVIGATION_ITEMS = {
      'home'      => { :controller => :home,      :action => :show },
      'users'     => { :controller => :users,     :action => :index },
      'languages' => { :controller => :languages, :action => :index },
      'about'     => { :controller => :about,     :action => :show },
  }

  def navigation
    render :partial => 'layouts/navigation'
  end

  def navigation_items
    NAVIGATION_ITEMS
  end

end