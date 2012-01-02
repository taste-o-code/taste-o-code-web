class TasksController < ApplicationController

  def show
    @task = Task.where(language_id: params['language_id'], slug: params['id']).first
    redirect_to :root unless has_access?(@task)
  end

  def submit
    task = Task.where(language_id: params['language_id'], slug: params['id']).first
    source = params['source']
    submission = Submission.create(:task => task, :user => current_user,
                                   :result => :testing, :source => source,
                                   :time => DateTime.now)
    time = submission.time.strftime('%H:%M:%S %d %b')
    response = { :submission_id => submission.id, :time => time }
    render :json => response
  end

  def check_submissions
    ids = params['ids'] || []
    response = ids.map do |id|
      submission = Submission.find(id)
      elapsed = ((DateTime.now - submission.time) * 24 * 60 * 60).to_i
      if elapsed > 10
        submission.result = (rand 2).even? ? :accepted : :failed
        submission.save
      end
      result = { :result => submission.result, :id => id }
      if submission.result == :failed
        result.merge!({ :reason => submission.fail_cause })
      end
      result
    end
    render :json => response
  end

  private

  def has_access?(task)
    current_user && current_user.has_language?(task.language)
  end
end
