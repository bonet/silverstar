# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  
  attr_accessor :password # virtual attribute (a.k.a not in the database).  User class already has :email and :password attributes -> from Users db table columns

  attr_accessible :email, :name, :password, :password_confirmation # for "new User(params_array)" (a.k.a mass assignment)
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence => true,
                   :length => { :maximum => 50 }
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => { :if =>  :new_user_or_password_parameter_exists? }, 
                       :confirmation => { :if =>  :new_user_or_password_parameter_exists? },  # automatically creates ':password_confirmation' virtual attribute
                       :length => { :if =>  :new_user_or_password_parameter_exists?, :within => 6..40 }
                       
  before_save :encrypt_password, :if => :new_user_or_password_parameter_exists?
  
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
      
  protected
  
    def new_user_or_password_parameter_exists?
      self.new_record? || self.password.present?
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
