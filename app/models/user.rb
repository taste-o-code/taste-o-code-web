class User

  include Mongoid::Document

  field :name
  field :location
  field :about

  auto_increment :id

  embeds_many             :authentications
  has_many                :submissions
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :solved_tasks, :class_name => 'Task', :inverse_of => nil
  has_and_belongs_to_many :unsubdued_tasks, :class_name => 'Task', :inverse_of => nil

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :location, :about, :current_password

  attr_writer :identity_url

  validates :name, :presence => true, :length => { :maximum => 30 },
            :format => {
                :with => /^[\w\-' ]+$/,
                :message => "can contain only letters, digits, spaces, hyphens, underscores and apostrophes."
            }

  validates :email,
            :presence => { :unless => :omniauth_user? },
            :uniqueness => { :case_sensitive => false, :allow_blank => true },
            :format => { :with => Devise::email_regexp,
                         :allow_blank => true,
                         :if => :email_changed? }

  validates :password,
            :presence => { :unless => :omniauth_user?, :on => :create },
            :length => { :minimum => 6, :allow_blank => true },
            :confirmation => true

  validates_length_of :location, :maximum => 100
  validates_length_of :about, :maximum => 1000


  def apply_omniauth(omniauth)
    info = omniauth['user_info']
    self.email = omniauth['user_info']['email'] if email.blank? and not info['email'].blank?
    if self.name.blank?
      name = [info['nickname'], info['name'], [info['first_name'], info['last_name']].join(' ')].detect(&:present?)
      self.name = name
    end
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def gravatar(size)
    hash = Digest::MD5.hexdigest(self.email.strip.downcase)
    "http://www.gravatar.com/avatar/#{hash}?s=#{size}"
  end

  def change_password(params={})
    current_password = params.delete(:current_password)

    result = if params[:password].blank?
      self.errors.add(:password, :blank)
      false
    elsif current_password.blank? or not valid_password?(current_password)
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    else
      # Update only passwords.
      update_attributes params.extract!(:password, :password_confirmation)
    end

    clean_up_passwords
    result
  end

  def omniauth_user?
    not authentications.blank?
  end

end
