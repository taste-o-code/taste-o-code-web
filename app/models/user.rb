
class User

  include Mongoid::Document

  field :name
  field :location
  field :facebook_id

  auto_increment :id

  embeds_many :open_id_identities

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :openid_authenticatable, :omniauthable

  AX_FIRST_NAME = 'http://axschema.org/namePerson/first'
  AX_LAST_NAME  = 'http://axschema.org/namePerson/last'
  AX_EMAIL      = 'http://axschema.org/contact/email'
  EMAIL         = 'email'
  FULLNAME      = 'fullname'
  NICKNAME      = 'nickname'

  attr_accessible :name, :email, :password, :password_confirmation,
                  :remember_me, :location, :facebook_id

  attr_writer :identity_url

  validates_presence_of   :name
  validates_format_of     :name, :with => /[\w' ]{2,30}/, :message => "Name consists of 2-30 symbols. Symbols a-z,A-Z,_,0-9."

  validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true
  validates_format_of     :email, :with => Devise::email_regexp, :allow_blank => true, :if => :email_changed?

  validates_length_of :password, :within => Devise::password_length, :allow_blank => true


  class << self

    def find_by_identity_url(identity_url)
      User.where(:open_id_identities.matches => { :identity_url => identity_url }).first
    end

    def build_from_identity_url(identity_url)
      user = User.new
      user.open_id_identities << OpenIdIdentity.new(:identity_url => identity_url)
      user
    end

    def openid_required_fields
      [AX_FIRST_NAME, AX_LAST_NAME, AX_EMAIL, FULLNAME, NICKNAME, EMAIL]
    end

    def find_for_facebook_oauth(data, signed_in_resource=nil)
      user = User.where({'facebook_id' => data['id']}).first
      user || User.create(:email => data['email'],
                          :name => data['name'],
                          :location => data['location']['name'],
                          :facebook_id => data['id'])
    end
  end


  def openid_fields=(fields)
    # Some AX providers can return multiple values per key.
    # Leave only first element from all arrays.
    fields = fields.inject({}) { |h, (k,v)| h.merge k => v.is_a?(Array) ? v.first : v }

    self.name ||= fields[NICKNAME] || fields[FULLNAME] || [fields[AX_FIRST_NAME], fields[AX_LAST_NAME]].compact.join(' ')
    self.email = fields[EMAIL] || fields[AX_EMAIL]
  end

  def identity_url
    @identity_url ||= open_id_identities.first.try(:identity_url)
  end

  def gravatar(size)
    hash = Digest::MD5.hexdigest(self.email.strip.downcase)
    "http://www.gravatar.com/avatar/#{hash}?s=#{size}"
  end

  def update_with_password(params={})
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    # Check current password only when user changes password.
    result = if params[:password].blank? or valid_password?(current_password)
      update_attributes(params)
    else
      self.attributes = params
      self.valid?
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end

    clean_up_passwords
    result
  end

  def has_no_password?
    self.encrypted_password.blank?
  end

end
