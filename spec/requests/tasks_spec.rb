require 'spec_helper'

describe TasksController do

  let(:lang) { create(:language, price: 0) }
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

    it 'replaces <pre><code> with CodeMirror in description', js: true do
      visit task_page
      page.should have_css('.description .CodeMirror')
    end

    it 'contains link to language page' do
      visit task_page
      click_link lang.name
      current_path.should == language_path(lang)
    end

    # TODO: why does it fail on travis-ci (http://travis-ci.org/#!/taste-o-code/taste-o-code-web/builds/747131)?
    it "submits user's solution'", js: true, ci: 'skip' do
      source = 'print "Hello, world!"'

      visit task_page

      submit_solution source

      find('#submissions tr[data-testing="true"]')

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

    it 'does not allow user to submit an empty solution', js: true do
      visit task_page

      submit_solution ''
      lambda { find('#submissions tr[data-testing="true"]') }.should raise_error

      Submission.first.should be_nil
    end

    it 'shows submission results in titles' do
      accepted = Submission.create(user: user, task: task, result: :accepted)
      failed = Submission.create(user: user, task: task, result: :failed, fail_cause: 'o_O')

      visit task_page

      page.should have_css("tr[data-submission-id='#{accepted.id}'] img[title='Accepted']")
      page.should have_css("tr[data-submission-id='#{failed.id}'] img[title='o_O']")
    end

    it "doesn't show comments section" do
      visit task_page
      page.should_not have_content('Comments')
    end

    it 'shows solution template' do
      visit task_page

      template_on_page = find_field('source').value.strip
      template_on_page.should eq(task.template)
    end

    context 'solved task' do
      before(:each) { user.task_accepted(task) }

      it 'shows comments section' do
        visit task_page
        page.should have_content('Comments')
      end

      it "says 'No comments' when there are no comments" do
        visit task_page
        page.should have_content('No comments')
      end

      it 'shows comments when there are some' do
        comment = create(:comment)

        visit task_page

        comments_block = find('#comments')

        comments_block.should have_content(comment.body)
        comments_block.should have_content(comment.user.name)
      end

      it 'allows user to leave a comment', js: true do
        body = 'Hello, kitty!'

        visit task_page

        fill_in 'body', with: body
        click_button 'Comment'

        page.should have_content(body)
        page.should_not have_content('No comments')
      end
    end

  end

  context 'when the user has no access to the task' do
    it 'does not show submit button to a user that is not authenticated' do
      visit task_page
      page.should have_no_css('#submit_button')
    end

    it "does not show submit button to the user who didn't buy it'" do
      create_and_login_user
      visit task_page
      page.should have_no_css('#submit_button')
    end
  end

  def submit_solution(source)
    page.execute_script "window.sourceEditor.setValue('#{source}')"
    click_button 'submit_button'
  end

end
