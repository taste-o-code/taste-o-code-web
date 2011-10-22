require 'digest/md5'


class User

  include Mongoid::Document

  AX_FIRST_NAME = 'http://axschema.org/namePerson/first'
  AX_LAST_NAME =  'http://axschema.org/namePerson/last'
  AX_EMAIL = 'http://axschema.org/contact/email'
  EMAIL = 'email'
  FULLNAME = 'fullname'
  NICKNAME = 'nickname'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :openid_authenticatable

  field :name

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  attr_writer :identity_url

  embeds_many :open_id_identities

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false

  validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true
  validates_format_of     :email, :with => Devise::email_regexp, :allow_blank => true, :if => :email_changed?

  validates_length_of :password, :within => Devise::password_length, :allow_blank => true

  # Class methods
  class << self 
    def find_by_identity_url(identity_url)
      User.where(:open_id_identities.matches => {:identity_url => identity_url}).first
    end

    def build_from_identity_url(identity_url)
      user = User.new
      user.open_id_identities << OpenIdIdentity.new(:identity_url => identity_url)
      return user
    end

    def openid_required_fields
      [AX_FIRST_NAME, AX_LAST_NAME, AX_EMAIL, FULLNAME, NICKNAME, EMAIL]
    end
  end

  # Instance methods
  def openid_fields=(fields)
    # Some AX providers can return multiple values per key
    # Leave only first element from all arrays.
    fields = fields.inject({}) do |h, (k,v)|
      h[k] = v.is_a?(Array) ? v.first : v
      h
    end      

    self.name = fields[NICKNAME] || fields[FULLNAME] || [fields[AX_FIRST_NAME], fields[AX_LAST_NAME]].compact.join(' ')
    self.email = fields[EMAIL] || fields[AX_EMAIL]
  end

  def identity_url
    @identity_url ||= open_id_identities.first.try(:identity_url)
  end

  def gravatar
    hash = Digest::MD5.hexdigest(self.email.strip.downcase)
    return "http://www.gravatar.com/avatar/#{hash}?s=40"
  end

end
