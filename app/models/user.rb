class User

  include Mongoid::Document

  INITIAL_POINTS = 30

  field :name, type: String
  field :location, type: String
  field :about, type: String
  field :total_points, type: Integer
  field :available_points, type: Integer

  ## Database authenticatable
  field :email,              type: String, null: false
  field :encrypted_password, type: String, null: false

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time

  auto_increment :id

  embeds_many             :omniauth_identities
  has_many                :submissions
  has_many                :comments
  has_and_belongs_to_many :languages, :inverse_of => nil
  has_and_belongs_to_many :solved_tasks, :class_name => 'Task', :inverse_of => nil
  has_and_belongs_to_many :unsubdued_tasks, :class_name => 'Task', :inverse_of => nil

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable, :confirmable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :location, :about, :current_password

  attr_writer :identity_url

  before_update :generate_confirmation_token, :if => :email_changed?
  after_update  :send_confirmation_instructions, :if => :email_changed?

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

  validates_numericality_of :total_points,
                            :greater_than => 0,
                            :only_integer => true
  validates_numericality_of :available_points,
                            :greater_than_or_equal_to => 0,
                            :only_integer => true

  after_initialize :init

  def init
    self.total_points ||= INITIAL_POINTS
    self.available_points ||= INITIAL_POINTS
  end

  def buy_language(lang)
    if available_points >= lang.price and not has_language?(lang)
      self.available_points -= lang.price
      languages << lang
      save
    else
      false
    end
  end

  def has_language?(lang)
    language_ids.include? lang.id
  end

  def solved_tasks_for_lang(lang)
    solved_tasks.where(language_id: lang.id).to_a
  end

  def unsubdued_tasks_for_lang(lang)
    unsubdued_tasks.where(language_id: lang.id).to_a
  end

  def percent_solved_for_lang(lang)
    result = solved_tasks_for_lang(lang).count / lang.tasks.count.to_f
    100 * (result.nan? ? 1 : result)
  end

  def task_accepted(task)
    return if solved_task_ids.include? task.id
    self.solved_tasks << task
    self.unsubdued_task_ids.delete task.id
    self.available_points += task.award
    self.total_points += task.award
    save
  end

  def task_failed(task)
    unless solved_task_ids.include? task.id or unsubdued_task_ids.include? task.id
      self.unsubdued_tasks << task
      save
    end
  end

  def submissions_for_task(task)
    Submission.where(user_id: id, task_id: task.id).desc(:created_at)
  end

  def apply_omniauth(omniauth)
    info = omniauth['info']
    self.email = info['email'] if email.blank? and not info['email'].blank?
    if name.blank?
      self.name = [info['nickname'], info['name'], [info['first_name'], info['last_name']].join(' ')].detect(&:present?)
    end
    omniauth_identities.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def change_password(params={})
    current_password = params.delete(:current_password)

    result = if params[:password].blank?
      errors.add(:password, :blank)
      false
    elsif current_password.blank? or not valid_password?(current_password)
      errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    else
      # Update only passwords.
      update_attributes params.extract!(:password, :password_confirmation)
    end

    clean_up_passwords
    result
  end

  def omniauth_user?
    omniauth_identities.present?
  end

end
