require 'spec_helper'

describe Submission do

  describe '#pretty_submission_time' do
    it 'returns pretty formatted submission time' do
      time = Time.now
      Submission.new(created_at: time).pretty_submission_time.should == time.strftime('%H:%M:%S %d %b %Y')
    end
  end

end