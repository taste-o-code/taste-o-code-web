class TasksController < ApplicationController

  def show
    @lang = Language.find(params[:language_id])
    @task = @lang.tasks.where(slug: params[:id]).first

    return redirect_to(:root) unless has_access?(@task)

    @submissions = current_user.submissions_for_task(@task).page(params[:page]).per(5)
    @comments = @task.comments.includes(:user).order(:created_at)

    styx_initialize_with syntax_mode: @lang.syntax_mode, language: @lang.id, task: @task.slug
  end

  def submissions
    if user_signed_in?
      lang = Language.find(params[:language_id])
      task = lang.tasks.where(slug: params[:id]).first

      @submissions = current_user.submissions_for_task(task).page(params[:page]).per(5)
    end
  end

  def submit
    task = Task.find_by_slug params[:language_id], params[:id]

    submission = Submission.create(
        user:   current_user,
        task:   task,
        result: Submission::TESTING,
        source: params[:source],
    )

    enqueue_submission submission

    render json: { submission_id: submission.id, created_at: submission.pretty_submission_time }
  end

  private

  def has_access?(task)
    current_user && current_user.has_language?(task.language)
  end

  def enqueue_submission(submission)
    job = {
        source: submission.source,
        task:   submission.task.slug,
        lang:   submission.task.language.id,
        id:     submission.id
    }

    queue        = Rails.configuration.resque[:queue_pyres]
    worker_class = Rails.configuration.resque[:worker_pyres]

    Resque.push(queue, class: worker_class, args: [job])
  end

end
