class SubmissionsController < ApplicationController

  def index
    render json: {
      submissions: Submission.any_in(_id: params[:ids]).map(&:to_hash),
      available_points: current_user.available_points,
      total_points: current_user.total_points
    }
  end

  def source
    render :json => { source: Submission.find(params[:id]).source }
  end

end
