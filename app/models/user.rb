
class User

  include Mongoid::Document

  field :name
  field :location

  auto_increment :id

  embeds_many :authentications

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable

  attr_accessible :name, :email, :password, :password_confirmation,
                  :remember_me, :location

  attr_writer :identity_url

  validates_presence_of   :name
  validates_format_of     :name, :with => /[\w' ]{2,30}/, :message => "Name consists of 2-30 symbols. Symbols a-z,A-Z,_,0-9."

  validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true
  validates_format_of     :email, :with => Devise::email_regexp, :allow_blank => true, :if => :email_changed?

  validates_length_of :password, :within => Devise::password_length, :allow_blank => true

  def apply_omniauth(omniauth)
    info = omniauth['user_info']
    self.email = omniauth['user_info']['email'] if email.blank? and not info['email'].blank?
    if self.name.blank?
      name = [info['nickname'], info['name'], [info['first_name'], info['last_name']].join(' ')].detect(&:present?)
      self.name = name
    end
    authentications.build(:provider => omniauth['provider'],
                          :uid => omniauth['uid'])
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
