describe SubmissionResultHandler do

  before(:each) do
    @user = create(:user_with_languages)
    @task = @user.languages.first.tasks.first
    @submission = Submission.create :user => @user, :task => @task
    Submission.stub :find => @submission
  end

  it 'should process accepted submission' do
    result_to_handle = { 'id' => @submission.id.to_s, 'result' => 'accepted' }
    @user.should_receive(:task_accepted).with(@task)

    SubmissionResultHandler.perform result_to_handle

    @submission.reload
    @submission.result.should eq(Submission::ACCEPTED)
    @submission.fail_cause.should be_blank
  end

  it 'should process failed submission' do
    fail_cause = 'A-ta-ta'
    result_to_handle = { 'id' => @submission.id.to_s, 'result' => 'failed', 'fail_cause' =>  fail_cause }
    @user.should_receive(:task_failed).with(@task)

    SubmissionResultHandler.perform result_to_handle

    @submission.reload
    @submission.result.should eq(Submission::FAILED)
    @submission.fail_cause.should eq(fail_cause)
  end

end
