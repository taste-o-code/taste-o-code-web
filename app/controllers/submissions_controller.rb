class SubmissionsController < ApplicationController

  def index
    render :json => Submission.criteria.for_ids(params[:ids]).map(&:to_hash)
  end

  def source
    render :json => { source: Submission.find(params[:id]).source }
  end

end