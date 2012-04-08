require 'spec_helper'

describe TasksController do

  let(:lang) { Factory(:language, price: 0) }
  let(:task) { lang.tasks.first }
  let(:task_page) { language_task_path(lang, task) }

  context 'when user has access to the task' do
    let(:user) { create_and_login_user }

    before(:all) { Resque.redis = MockRedis.new }

    before(:each) do
      user.buy_language lang
      visit task_page
    end

    it 'allows user to see visit the task page' do
      current_path.should == task_page
    end

    it 'renders markdown in description' do
      find('.description p em').should have_content('Description')
    end

    it 'replaces <pre><code> with CodeMirror in description', :js => true do
      page.should have_css('.description .CodeMirror')
    end

    it 'contains link to language page' do
      click_link lang.name
      current_path.should == language_path(lang)
    end

    # TODO: why does it fail on travis-ci (http://travis-ci.org/#!/taste-o-code/taste-o-code-web/builds/747131)?
    it "submits user's solution'", :js => true, :ci => 'skip' do
      source = 'print "Hello, world!"'
      submit_solution source

      find('.submission[data-testing="true"]')

      submission = Submission.first

      submission.user_id.should == user.id
      submission.task_id.should == task.id
      submission.source.should  == source
      submission.result.should  == :testing

      job = Resque.pop(Rails.configuration.resque[:queue_pyres])

      job['class'].should == Rails.configuration.resque[:worker_pyres]
      job['args'].should  == [{
          'id'     => submission.id.to_s,
          'source' => submission.source,
          'task'   => submission.task.position,
          'lang'   => submission.task.language.id
      }]
    end

    it 'does not allow user to submit an empty solution', :js => true do
      submit_solution ''
      lambda { find('.submission[data-testing="true"]') }.should raise_error

      Submission.first.should be_nil
    end

  end

  context 'when the user has no acces to the task' do
    it 'does not show the task to a user that is not authenticated' do
      visit task_page
      current_path.should_not == task_page
    end

    it "does not show the task to the user who didn't buy it'" do
      create_and_login_user
      visit task_page
      current_path.should_not == task_page
    end
  end

  def submit_solution(source)
    page.execute_script "window.sourceEditor.setValue('#{source}')"
    click_button 'submit_button'
  end

end
