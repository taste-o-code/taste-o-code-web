require 'spec_helper'

describe TasksController do

  it 'should return submission results' do
    testing  = Submission.create :result => Submission::TESTING
    accepted = Submission.create :result => Submission::ACCEPTED
    failed   = Submission.create :result => Submission::FAILED, :fail_cause => 'A-ta-ta'

    get :check_submissions, :ids => Submission.all.map(&:id)

    resp = JSON.parse(response.body).map(&:symbolize_keys)

    [testing, accepted, failed].each do |s|
      resp.should include(s.to_hash)
    end
  end

  it 'should return submission source' do
    submission = Submission.create :source => 'Bla-bla-bla'
    get :get_submission_source, :id => submission.id
    resp = JSON.parse response.body

    resp['source'].should eq(submission.source)
  end
end
