class SubmissionResultHandler

  @queue = :submission_results

  def self.perform(result)
    submission = Submission.find result['id']
    submission.result = result['result'].to_sym
    if submission.accepted?
      submission.user.task_accepted submission.task
    else
      submission.user.task_failed submission.task
      submission.fail_cause = result['fail_cause']
    end
    submission.save
  end

end
