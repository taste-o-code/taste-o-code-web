class Language

  include Mongoid::Document
  include ActiveAdmin::Mongoid::Patches

  has_many :tasks,  order: [:position, :asc]

  field :_id,         type: String
  field :description, type: String
  field :links,       type: Array
  field :price,       type: Integer
  field :name,        type: String
  field :syntax_mode, type: String

end

