require 'spec_helper'

describe SubmissionsController do

  describe '#index' do
    it 'returns submissions results' do
      # Prepare
      user = Factory(:user, available_points: 42, total_points: 84)
      sign_in user
      testing  = Submission.create(result: Submission::TESTING)
      accepted = Submission.create(result: Submission::ACCEPTED)
      failed   = Submission.create(result: Submission::FAILED, fail_cause: 'A-ta-ta')

      # Run
      get :index, ids: Submission.all.map(&:id)

      # Validate
      resp = JSON.parse(response.body)
      submissions = resp['submissions'].map(&:symbolize_keys)

      resp['available_points'].should eq(42)
      resp['total_points'].should eq(84)

      [testing, accepted, failed].each do |submission|
        submissions.should include(submission.to_hash)
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
