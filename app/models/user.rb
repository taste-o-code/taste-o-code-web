class User

  include Mongoid::Document

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

  field :name

  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

end
