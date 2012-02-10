class Task

  include Mongoid::Document
  include ActiveAdmin::Mongoid::Patches

  belongs_to :language
  has_many   :submissions

  field :name, type: String
  field :slug, type: String
  field :position, type: Integer
  field :description, type: String
  field :award, type: Integer

  validates_uniqueness_of :slug, scope: :language_id

  def to_param
    slug
  end
end
