class Submission

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :user
  belongs_to :task, :inverse_of => nil

  field :source, type: String
  field :result, type: Symbol
  field :fail_cause, type: String

  def pretty_submission_time
    created_at.strftime('%H:%M:%S %d %b %Y')
  end

end
