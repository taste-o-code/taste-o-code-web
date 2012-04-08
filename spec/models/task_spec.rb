require 'spec_helper'

describe Task do

  it 'should find tasks by slug' do
    lang = FactoryGirl.create :language
    task = lang.tasks.first

    found_task = Task.find_by_slug(lang.id, task.slug)
    found_task.id.should eq(task.id)
  end

end
