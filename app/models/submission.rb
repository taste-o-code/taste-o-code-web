class Submission
  include Mongoid::Document

  belongs_to :user
  belongs_to :task, :inverse_of => nil

end
