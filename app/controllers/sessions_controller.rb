class SessionsController < Devise::SessionsController

  def create
    respond_to do |format|
      format.json do
        warden.authenticate! :scope => resource_name
        render :json => { :message => 'Reloading...' }
      end

      format.html { super }
    end
  end

end
