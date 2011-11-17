class OmniauthIdentity

  include Mongoid::Document

  embedded_in :user

  field :provider
  field :uid

end
