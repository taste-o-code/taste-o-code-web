class Submission

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :user
  belongs_to :task, :inverse_of => nil

  field :source, type: String
  field :result, type: Symbol
  field :fail_cause, type: String

  HASH_ATTRIBUTES = [:id, :result, :fail_cause]

  TESTING  = :testing
  ACCEPTED = :accepted
  FAILED   = :failed
  RESULTS  = [TESTING, ACCEPTED, FAILED]

  validates_inclusion_of :result, in: RESULTS

  def pretty_submission_time
    created_at.strftime('%H:%M:%S %d %b %Y')
  end

  def fail_cause
    self['fail_cause'] if result == FAILED
  end

  def to_hash
    HASH_ATTRIBUTES.each_with_object({}) do |attr, memo|
      value = send(attr)
      memo[attr] = value.to_s unless value.nil?
    end
  end

  RESULTS.each do |expected_result|
    define_method "#{expected_result}?" do
      result == expected_result
    end
  end

end
