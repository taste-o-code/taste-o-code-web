class CommentsController < ApplicationController

  def create
    comment = current_user.comments.new(task_id: params[:task_id], body: params[:body])

    if comment.save
      render json: { comment: render_to_string(partial: 'tasks/comment', locals: { comment: comment }) }
    else
      render json: { error: 'Failed to save the comment.' }
    end
  end

end