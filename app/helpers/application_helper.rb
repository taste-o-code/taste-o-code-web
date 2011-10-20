require 'digest/md5'

module ApplicationHelper

  def gravatar_link(email)
    hash = Digest::MD5.hexdigest(email.strip.downcase)
    return "http://www.gravatar.com/avatar/#{hash}?s=40"
  end

end
