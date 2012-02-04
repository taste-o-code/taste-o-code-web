require 'spec_helper'

describe TasksController do

  it 'should return submission results' do
    testing = Submission.create :result => :testing
    accepted = Submission.create :result => :accepted
    failed = Submission.create :result => :failed, :fail_cause => 'A-ta-ta'
    ids = Submission.all.map{ |s| s.id.to_s }

    get :check_submissions, :ids => ids

    resp = JSON.parse response.body
    [testing, accepted, failed].each do |s|
      resp.should include(to_hash s)
    end
  end

  def to_hash(submission)
    hash = { 'id' => submission.id.to_s, 'result' => submission.result.to_s }
    hash['fail_cause'] = submission.fail_cause if submission.result == :failed
    hash
  end
end
