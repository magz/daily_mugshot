class Authuser < ActiveRecord::Base
  has_many :mugshots
  has_many :comments
  has_many :landmarks
  has_one :twitter_connect
  validates :login, :email, :gender, :crypted_password, :birthday, :presence => true
  validates :login, :uniqueness => true
  
  #this is the same as authenticate_either in the old code
  #i don't see much reason to have them be separate functions
  def self.authenticate(login, password)
    u = Authuser.where(:login => login).first || Authuser.where(:email => login).first
    #make sure you handle encryption here
    (u && (password == u.crypted_password)) ? u : nil
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

end
