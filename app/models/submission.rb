class Submission
  include Mongoid::Document

  belongs_to :user
  belongs_to :task, :inverse_of => nil

  field :source, type: String
  field :time, type: DateTime
  field :result, type: Symbol
  field :fail_cause, type: String

end
