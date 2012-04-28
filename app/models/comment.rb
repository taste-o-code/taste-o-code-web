class Comment

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :task
  belongs_to :user

  field :body, type: String

  validates :body, presence: true
  validates :task, presence: true
  validates :user, presence: true

end