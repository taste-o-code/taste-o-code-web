require 'spec_helper'

describe ApplicationHelper do

  it 'should render markdown' do
    text = "*Hello*"

    rendered = helper.markdown text

    rendered.strip.should eq('<p><em>Hello</em></p>')
  end
end
