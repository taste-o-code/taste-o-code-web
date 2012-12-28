class Task

  include Mongoid::Document

  belongs_to :language
  has_many   :submissions
  has_many   :comments

  field :name, type: String
  field :slug, type: String
  field :position, type: Integer
  field :description, type: String
  field :award, type: Integer
  field :template, type: String

  validates_uniqueness_of :slug, scope: :language_id

  def self.find_by_slug(language_id, slug)
    where(language_id: language_id, slug: slug).first
  end

  def to_param
    slug
  end

end
