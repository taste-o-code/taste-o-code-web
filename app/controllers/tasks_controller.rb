class TasksController < ApplicationController

  def show
    @lang = Language.find(params[:language_id])
    @task = @lang.tasks.where(slug: params[:id]).first

    if has_access? @task
      @submissions = current_user.submissions_for_task(@task).page(params[:page]).per(5)
      styx_initialize_with :syntax_mode => @lang.syntax_mode
    else
      redirect_to :root
    end
  end

  def submit
    task = Task.find_by_slug params[:id], params[:language_id]

    submission = Submission.create(
        :task   => task,
        :user   => current_user,
        :result => :testing,
        :source => params[:source],
        :time   => DateTime.now
    )
    enqueue_submission submission

    render :json => { :submission_id => submission.id, :time => submission.time.strftime('%H:%M:%S %d %b') }
  end

  def check_submissions
    response = params[:ids].map do |id|
      submission = Submission.find(id)

      result = { :result => submission.result, :id => id }
      result.merge!(:fail_cause => submission.fail_cause) if submission.result == :failed
      result
    end

    render :json => response
  end

  def get_submission_source
    submission = Submission.find params[:id]
    render :json => { source: submission.source }
  end

  private

  def has_access?(task)
    current_user && current_user.has_language?(task.language)
  end

  def enqueue_submission(submission)
    job = {
      :source => submission.source,
      :task => submission.task.position,
      :lang => submission.task.language.id,
      :id => submission.id
    }
    queue = Rails.configuration.resque[:queue_pyres]
    worker_class = Rails.configuration.resque[:worker_pyres]
    Resque.push(queue, :class => worker_class, :args => [job])
  end

end
