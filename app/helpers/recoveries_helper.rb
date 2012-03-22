require 'digest'

module RecoveriesHelper

  def rec_key(email)
    Digest::SHA2.hexdigest("#{Time.now.utc}--#{email}")
  end

end
