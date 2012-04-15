require 'spec_helper'

describe SubmissionsController do

  describe '#index' do
    it 'returns submissions results' do
      testing  = Submission.create(result: Submission::TESTING)
      accepted = Submission.create(result: Submission::ACCEPTED)
      failed   = Submission.create(result: Submission::FAILED, fail_cause: 'A-ta-ta')

      get :index, ids: Submission.all.map(&:id)

      resp = JSON.parse(response.body).map(&:symbolize_keys)

      [testing, accepted, failed].each do |submission|
        resp.should include(submission.to_hash)
      end
    end
  end

  describe '#source' do
    it 'returns submission source' do
      submission = Submission.create(source: 'Bla-bla-bla', result: Submission::ACCEPTED)

      get :source, id: submission.id

      JSON.parse(response.body)['source'].should == submission.source
    end
  end

end
