class SessionsController < Devise::SessionsController

  def create
    respond_to do |format|
      format.json do
        resource = warden.authenticate! :scope => resource_name, :recall => 'sessions#failure'
        render :json => {
            :success => true,
            :message => 'Redirecting...',
            :redirect => redirect_location(resource_name, resource)
        }
      end

      format.html { super }
    end
  end

  def failure
    render :json => { :success => false, :message => 'Invalid email or password.' }
  end

end
