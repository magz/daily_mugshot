require 'digest/sha1'

class Authuser < ActiveRecord::Base
  has_many :mugshots
  has_many :comments
  has_many :landmarks
  has_one :twitter_connect
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :authuser
  has_many :landmarks
  
  validates :terms_of_service, :acceptance => true
  validates :login, :email, :gender, :crypted_password, :birthday, :presence => true
  validates :login, :email, :uniqueness => true
  
  before_save :set_init_vals
  # before_save :encrypt_password
  #this is the same as authenticate_either in the old code
  #i don't see much reason to have them be separate functions
  def set_init_vals
    self.time_zone ||= "US/Eastern"
    self.active ||= true
    self.gender ||= "m"
  end
  
  def deleted?
    !self.delted_at == nil
  end
  def self.authenticate(login, password)
    
    u = Authuser.where(:login => login).first || Authuser.where(:email => login).first
    if u && u.crypted_password == Authuser.encrypt(password, u.salt)
      return u
    else
      return false
    end
  end 
  
  def consistency
    if self.has_mugshot?
      (self.mugshots.count / ((Date.today - self.mugshots.first.created_at.to_datetime).to_f)) * 100 
    else
      100
    end
  end
  def last_mugshot_date
    self.mugshots.last.created_at
  end
  
  def self.users_with_mugshots
    temp = []
    Authuser.all.each do |user|
      if user.has_mugshot?
        temp << user
      end
    end
    temp
  end 
  def has_mugshot?
    self.mugshots.first != nil
  end
  
  def twittering?
    self.twitter_connect && self.twitter_connect.active?
  end
  def tweeting?
    self.twittering?
  end
  
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  def login_from_cookie
    return unless cookies[:_daily_mugshot_auth_token] && !logged_in?
    user = Authuser.find_by_remember_token(cookies[:_daily_mugshot_auth_token])
    if user && user.remember_token?
      user.remember_me
      self.current_authuser = user
      cookies[:_daily_mugshot_auth_token] = { :value => self.current_authuser.remember_token , :expires => self.current_authuser.remember_token_expires_at }
      flash[:notice] = "Logged in successfully"
    end
  end
  
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end
  
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = Digest::SHA1.hexdigest("#{email}--#{remember_token_expires_at}")
    save
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save
  end
  
  def taken_pic_today?
    self.mugshots.last and self.mugshots.last.created_at.in_time_zone(self.time_zone).to_date == Time.now.in_time_zone(self.time_zone).to_date
  end
    
  def encrypt_password
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password =  Authuser.encrypt(password, salt)
  end
  def already_taken_today?
    #take into account tz here
    self.mugshots.last.created_at.to_date == Date.today
  end
  
end
