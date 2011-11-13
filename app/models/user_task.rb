class UserTask

  include Mongoid::Document

  embedded_in :user_language

  belongs_to :task

end
