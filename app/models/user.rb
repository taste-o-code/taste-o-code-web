class User

  include Mongoid::Document

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

  field :name

  validates_presence_of   :name
  validates_uniqueness_of :name, :case_sensitive => false

  validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true
  validates_format_of     :email, :with => Devise::email_regexp, :allow_blank => true, :if => :email_changed?

  validates_length_of :password, :within => Devise::password_length, :allow_blank => true

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

end
