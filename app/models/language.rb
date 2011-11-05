class Language

  include Mongoid::Document

  field :_id, type: String
  field :description, type:  String
  field :links, type: Array
  field :price, type: Integer
  field :name, type: String

end

