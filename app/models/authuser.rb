require 'digest/sha1'

class Authuser < ActiveRecord::Base
  has_many :mugshots
  has_many :comments
  has_many :landmarks
  has_one :twitter_connect
  has_one :email_reminder
  has_many :friendships
  has_many :friends, :through => :friendships, :source => :followee
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :authuser
  has_many :landmarks
  has_many :ip_address_hacks
  
  validates :login, :email, :gender, :crypted_password, :presence => true
  validates :login, :email, :uniqueness => true
  
  self.per_page = 18
  #after_create :init
  # before_save :encrypt_password
  #this is the same as authenticate_either in the old code
  #i don't see much reason to have them be separate functions
  
  before_save :full_update_stats
  def full_update_stats
    begin
      if self.mugshots != []
        self.last_mugshot = self.mugshots.last.id
        self.last_mugshot_url = Mugshot.find(self.last_mugshot).try_image(:inner)
        if self.mugshot_count == nil
          self.mugshot_count = self.mugshots.count
        else
          self.mugshot_count = self.mugshot_count + 1
        end
        self.consistency = ((self.mugshot_count * 1000) / (Date.today - self.mugshots.first.created_at.to_date).to_i)
      else
        self.last_mugshot = nil
        self.mugshot_count = 0
        self.consistency = 1
      end
    rescue
      puts "error with authuser id: " + self.id.to_s + "   login:   " + self.login
    end 
  end
  
  def update_stats
    begin
      self.mugshot_count = self.mugshots.count
      self.save
    rescue
    end
    
  end
  #these get methods are temporary and intended to be deleted once the database caching population is settled
  def get_mugshot_count
    self.mugshot_count || self.mugshots.count 
  end
  def get_consistency
    self.consistency || ((self.get_mugshot_count * 1000) / (Date.today - self.mugshots.first.created_at.to_date).to_i)
  end
  
  def get_last_mugshot
     if self.last_mugshot != nil
       self.last_mugshot
      else  
        if self.mugshots.last.present?
          self.mugshots.last
        else
          nil
        end
      end
  
  end
  
  # def init
  #   self.time_zone ||= "US/Eastern"
  #   self.active ||= true
  #   self.gender ||= "m"
  #   @email_reminder = EmailReminder.new
  #   @email_reminder.hour = 12
  #   @email_reminder.authuser_id = self.id
  #   @email_reminder.active = true
  #   @email_reminder.save
  #   self.save
  # end
  def get_all_images
    to_get = []
    
      self.mugshots.each do |m|
        if m.image.to_s.match("missing").class != NilClass
          to_get << m
        end
      end

      unless to_get == []
        f = AWS::S3.new.buckets[:dailymugshotprod]
        to_get.each do |m|
          begin
            i = f.objects[m.filename].url_for(:read).open 
            m.image = i
            m.save
            i.close
          rescue
          end
        end
      end


  end
  
  def gender_possessive
    if self.gender == "f"
      "her"
    else
      "his"
    end
  end
  def deleted?
    !self.delted_at == nil
  end
  def self.authenticate(login, password)
    #authentication for login
    
    u = Authuser.where(:login => login).first || Authuser.where(:email => login).first
    if u && u.crypted_password == Authuser.encrypt(password, u.salt)
      return u
    else
      return false
    end
  end 
  
  # def consistency
  #   #maybe cut people some slack on this to account for downtime?  i dunno w/e
  #   if self.has_mugshot?
  #     (self.mugshots.count / ((Date.today - self.mugshots.first.created_at.to_datetime).to_f)) * 100 
  #   else
  #     100
  #   end
  # end
  def last_mugshot_date
    self.mugshots.last.created_at
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
    #encryption for login
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
    #destroy remmeber token
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
    if self.has_mugshot?
      self.mugshots.last.created_at.to_date == Date.today
    else
      false
    end
  end
  def update_mugshot_count
    self.mugshot_count = self.mugshots.where(active: true).count
    self.save
  end
  
  # def cache_get_sequence
  #   File.open("tmp/get_sequence_cache/" + self.id.to_s + ".xml", 'w') {|f| f.write(Rails.app.get("/openapis/get_sequence?userid=" + self.id.to_s).response.body) }
  #   
  # end
  
  def try_image_all
    logger.info "beginning try_image_all for user:  " + self.id.to_s
    if !self.mugshots.first.present? && self.mugshots.first.image_file_name == nil
      logger.info "first mugshot is nil, proceding to check/populate others"
      self.mugshots.each do |m|
        begin
          m.try_image
        rescue
        end  
      end
    end
  end
end
