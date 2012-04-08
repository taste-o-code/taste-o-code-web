class Comment

  include Mongoid::Document

  belongs_to :task
  belongs_to :user

  field :body, type: String

end