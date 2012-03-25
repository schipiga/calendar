require 'digest'

module RecoveriesHelper

  # generate key for password recovery
  def rec_key(email)
    Digest::SHA2.hexdigest("#{Time.now.utc}--#{email}")
  end

end
