require 'spec_helper'

describe TasksController do

  before(:each) do
    @mock_redis = MockRedis.new
    Resque.redis = @mock_redis

    @lang = Factory :language, price: 0
    @task = @lang.tasks.first
    @task.description = '*Description*'
    @task.save
    @url = language_task_path @lang, @task
  end

  context 'user with access to task' do

    before(:each) do
      @user = create_and_login_user
      @user.buy_language @lang
      visit @url
    end

    it 'should render markdown in description' do
      page.find('.description p em').should have_content('Description')
    end

    it 'should contain link to language page' do
      click_link @lang.name

      current_path.should eq(language_path @lang)
    end

    # TODO: why does it fail on travis-ci (http://travis-ci.org/#!/taste-o-code/taste-o-code-web/builds/747131)?
    it 'should submit solution', :js => true, :ci => 'skip' do
      source =  'print "Hello, world!"'
      submit_solution source
      find('.submission[data-testing="true"]')

      should_save_submission source
      should_enqueue_job
    end

    it 'should not submit empty solution', :js => true do
      submit_solution ''
      lambda { find('.submission[data-testing="true"]') }.should raise_error

      Submission.first.should be_nil
    end

    def submit_solution(source)
      page.execute_script "window.sourceEditor.setValue('#{source}')"
      click_button 'submit_button'
    end

    def should_save_submission(source)
      submission = Submission.first
      submission.user_id.should eq(@user.id)
      submission.task_id.should eq(@task.id)
      submission.source.should eq(source)
      submission.result.should eq(:testing)
    end

    def should_enqueue_job()
      job = Resque.pop Rails.configuration.resque[:queue_pyres]
      submission = Submission.first
      expected_args = {
        'id' => submission.id.to_s,
        'source' => submission.source,
        'task' => submission.task.position,
        'lang' => submission.task.language.id
      }
      job['class'].should eq(Rails.configuration.resque[:worker_pyres])
      job['args'].should eq([expected_args])
    end


  end

  context 'user without access to task' do

    it 'should not show task for unauthenticated user' do
      visit @url

      current_path.should_not eq(@url)
    end

    it "should not show task for user, who didn't buy language" do
      create_and_login_user

      visit @url

      current_path.should_not eq(@url)
    end
  end

end
