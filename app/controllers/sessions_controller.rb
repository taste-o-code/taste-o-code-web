class SessionsController < Devise::SessionsController

  def create
    respond_to do |format|
      format.json do
        warden.authenticate! :scope => resource_name, :recall => 'sessions#failure'
        render :json => { :success => true, :message => 'Reloading...' }
      end

      format.html { super }
    end
  end

  def failure
    render :json => { :success => false, :message => 'Invalid email or password.' }
  end

end
