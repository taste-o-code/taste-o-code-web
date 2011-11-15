class Language

  include Mongoid::Document

  has_many :tasks

  field :_id,         type: String
  field :description, type: String
  field :links,       type: Array
  field :price,       type: Integer
  field :name,        type: String

end

