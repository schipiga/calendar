require 'digest'
class User < ActiveRecord::Base

  attr_accessor :password
  attr_accessible :fio, :email, :password, :password_confirmation
 
  has_many :events
  has_one :recovery
   
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :fio, :length => { :maximum => 50,
                               :message => 'uf01' }
  validates :email, :presence => { :message => 'ue01' },
                    :format => { :with => email_regex,
                                 :message => 'ue02' },
                    :uniqueness => { :case_sensitive => false,
                                     :message => 'ue03' }
  validates :password, :presence => { :message => 'up01' },
                       :confirmation => { :message => "up02" },
                       :length => { :within => 6..40,
                                    :too_short => 'up03',
                                    :too_long => 'up04' }
    
  before_save :encrypt_password

  def has_password? (submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
