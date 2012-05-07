require 'spec_helper'

describe Submission do

  it { should validate_inclusion_of(:result).to_allow(Submission::RESULTS) }

  describe '#pretty_submission_time' do
    it 'returns pretty formatted submission time' do
      time = Time.now
      Submission.new(created_at: time).pretty_submission_time.should == time.strftime('%H:%M:%S %d %b %Y')
    end
  end

  describe '#fail_cause' do
    it 'returns failure cause if submission failed' do
      Submission.new(result: Submission::FAILED, fail_cause: 'cause').fail_cause.should == 'cause'
    end

    it 'returns default message for failed submission if no fail cause specified' do
      Submission.new(result: Submission::FAILED).fail_cause.should == 'Unknown error.'
    end

    it "returns nil if submission didn't fail" do
      Submission.new(result: Submission::ACCEPTED, fail_cause: 'Wat?').fail_cause.should be_nil
    end
  end

  describe '#to_hash' do
    context 'submission is failed' do
      it 'returns submission info as a hash of strings including fail cause' do
        submission = Submission.new(result: Submission::FAILED, fail_cause: 'Godzilla')

        submission.to_hash.should == {
            id:         submission.id.to_s,
            result:     Submission::FAILED.to_s,
            fail_cause: 'Godzilla'
        }
      end
    end

    context 'submission is not failed' do
      it 'returns submission info as a hash of string without fail cause' do
        submission = Submission.new(result: Submission::ACCEPTED, fail_cause: 'Wat?')

        submission.to_hash.should == {
            id:         submission.id.to_s,
            result:     Submission::ACCEPTED.to_s,
        }
      end
    end
  end

  Submission::RESULTS.each do |result|
    describe "##{result}?" do
      it 'returns true if submission has corresponding result' do
        Submission.new(result: result).send("#{result}?").should be_true
      end

      it 'returns true if submission has a different result' do
        Submission.new(result: (Submission::RESULTS - [result]).shuffle.first).send("#{result}?").should be_false
      end
    end
  end

end
