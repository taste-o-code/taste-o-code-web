class UserLanguage

  include Mongoid::Document

  embedded_in :user

  belongs_to :language

  embeds_many :user_tasks

end
