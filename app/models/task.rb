class Task

  include Mongoid::Document

  belongs_to :language
  has_many   :submissions

end
