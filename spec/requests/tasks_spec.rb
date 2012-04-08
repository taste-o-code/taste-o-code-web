require 'spec_helper'

describe TasksController do

  let(:lang) { Factory(:language, price: 0) }
  let(:task) { lang.tasks.first }
  let(:task_page) { language_task_path(lang, task) }

  context 'when user has access to the task' do
    let(:user) { create_and_login_user }

    before(:all) { Resque.redis = MockRedis.new }

    before(:each) { user.buy_language(lang) }

    it 'allows user to see visit the task page' do
      visit task_page
      current_path.should == task_page
    end

    it 'renders markdown in description' do
      visit task_page
      find('.description p em').should have_content('Description')
    end

    it 'replaces <pre><code> with CodeMirror in description', :js => true do
      visit task_page
      page.should have_css('.description .CodeMirror')
    end

    it 'contains link to language page' do
      visit task_page
      click_link lang.name
      current_path.should == language_path(lang)
    end

    # TODO: why does it fail on travis-ci (http://travis-ci.org/#!/taste-o-code/taste-o-code-web/builds/747131)?
    it "submits user's solution'", :js => true, :ci => 'skip' do
      source = 'print "Hello, world!"'

      visit task_page
      submit_solution source

      find('.submission[data-testing="true"]')

      submission = Submission.first

      submission.user_id.should == user.id
      submission.task_id.should == task.id
      submission.source.should  == source
      submission.result.should  == Submission::TESTING

      job = Resque.pop(Rails.configuration.resque[:queue_pyres])

      job['class'].should == Rails.configuration.resque[:worker_pyres]
      job['args'].should  == [{
          'id'     => submission.id.to_s,
          'source' => submission.source,
          'task'   => submission.task.slug,
          'lang'   => submission.task.language.id
      }]
    end

    it 'does not allow user to submit an empty solution', :js => true do
      visit task_page

      submit_solution ''
      lambda { find('.submission[data-testing="true"]') }.should raise_error

      Submission.first.should be_nil
    end

    it 'shows comments section' do
      visit task_page
      find('#comments h4').should have_content('Comments')
    end

    it "says 'No comments' when there are no comments" do
      visit task_page
      find('#comments').should have_content('No comments')
    end

    it 'shows comments when there are some' do
      task.comments.create(body: 'First comment')

      visit task_page

      find('#comments').should have_content(task.comments.first.body)
    end

  end

  context 'when the user has no access to the task' do
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
