class TasksController < ApplicationController

  def show
    @task = Task.where(language_id: params['language_id'], slug: params['id']).first
    redirect_to :root unless has_access?(@task)
  end

  private

  def has_access?(task)
    current_user && current_user.has_language?(task.language)
  end
end
