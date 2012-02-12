require 'spec_helper'

describe Task do

  it 'should find tasks by slug' do
    lang = Factory.create :language
    task = lang.tasks.first

    found_task = Task.find_by_slug(task.slug, lang.id)
    found_task.id.should eq(task.id)
  end
end
