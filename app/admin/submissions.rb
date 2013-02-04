ActiveAdmin.register Submission do

  config.sort_order = "created_at_desc"

  index do
    column :user do |submission|
      submission.user && submission.user.name
    end
    column :language do |submission|
      lang = submission.task.language
      link_to lang.name, [:admin, lang]
    end
    column :task do |submission|
      task = submission.task
      link_to task.name, [:admin, task.language, task]
    end
    column :created_at
    column :result
    column :fail_cause
    column "Actions" do |submission|
      link_to "View", [:admin, submission]
    end
  end

  show do |submission|
    task = submission.task
    lang = task.language
    attributes_table do
      row :user
      row :language do
        submission.task.language
      end
      row :task
      row :created_at
      row :result
      row :fail_cause
      row :source do
        div :id => 'code_example' do
          pre do
            code :class => lang.syntax_mode do
                submission.source
            end
          end
        end
      end

    end
  end
end
