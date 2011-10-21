class OpenIdIdentity
  
  include Mongoid::Document

  embedded_in :user
  devise :openid_authenticatable

  attr_accessible :identity_url

  def self.openid_required_fields
    user.openid_required_fields
  end

  def self.build_from_identity_url(identity_url)
    new(:identity_url => identity_url)
  end

  def openid_fields=(fields)
    user.try(:openid_fields=, fields)
  end

end


