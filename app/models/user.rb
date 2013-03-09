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

class User

  include Mongoid::Document
  include Mongoid::Paperclip
  
  field :userid
  field :email
  field :username
  field :salt
  field :encrypted_password
  field :avatar_file_name
  field :avatar_content_type
  field :avatar_file_size
  field :avatar_updated_at
  
  index({ email: 1 }, { unique: true, name: "email_index" })
  index({ userid: 1 }, { unique: true, name: "userid_index" })
  
  #attr
  attr_accessor :password # virtual attribute (a.k.a not in the database).  User class already has :email and :password attributes -> from Users db table columns

  attr_accessible :email, :username, :password, :password_confirmation, :avatar # for "new User(params_array)" (a.k.a mass assignment)
  
  #validation
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :username, :presence => true,
                       :length => { :maximum => 20 },
                       :uniqueness => { :case_sensitive => false }
                   
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
                    
  validates :password, :presence => { :if =>  :new_user_or_password_parameter_exists? }, 
                       :confirmation => { :if =>  :new_user_or_password_parameter_exists? },  # automatically creates ':password_confirmation' virtual attribute
                       :length => { :if =>  :new_user_or_password_parameter_exists?, :within => 6..40 }
  
  
  #Paperclip Stuff
  has_mongoid_attached_file :avatar, 
                                :path           => '/project-silverstar/images/:id/:style.:extension',
                                :storage        => :s3,
                                :url            => ':s3_alias_url',
                                :s3_host_alias  => 's3-ap-southeast-1.amazonaws.com',
                                :s3_credentials => { 
                                                     :bucket => S3_CONFIG['aws_bucket'],
                                                     :access_key_id => S3_CONFIG['aws_access_key_id'],                   
                                                     :secret_access_key => S3_CONFIG['aws_secret_access_key'] 
                                                     },
                                :styles         => {
                                                     #:original => ['1920x1680>', :jpg],
                                                     :small    => ['100x100#',   :jpg],
                                                     :medium   => ['250x250',    :jpg],
                                                     #:large    => ['500x500>',   :jpg]
                                                     }
                             
  validates_attachment :avatar, :presence => { :if =>  :new_user_or_avatar_parameter_exists? },
                                :size => { :if =>  :new_user_or_avatar_parameter_exists?, :less_than => 5.megabytes },
                                :content_type => { :if =>  :new_user_or_avatar_parameter_exists?, :content_type => ['image/jpeg', 'image/png'] }
                                


  #Paperclip Stuff Ends
  
  before_save :encrypt_password, :if => :new_user_or_password_parameter_exists?
  
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

=begin
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
=end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
      
  protected
  
    def new_user_or_password_parameter_exists?
      self.new_record? || self.password.present?
    end
    
    def new_user_or_avatar_parameter_exists?
      self.new_record? || self.avatar.present?
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