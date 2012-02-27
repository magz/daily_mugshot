class Mugshot < ActiveRecord::Base
  belongs_to :authuser
  has_many :comments
  
  validates :authuser, :presence => true

  after_create :update_mugshot_count
  #after_create :do_social

  #cropper is a custom processor
  #it takes in the xoffset and yoffset and does cropping accordingly
  
  #in the refactored code this is THE configuration that determines the handling of the images
  #if you want to modify it, probably look here
  #the previous code di tons of overriding of the paperclip methods
  #this was the source of a tremendous amounts of its messiness
  #if you want to obscure the urls of the mugshots, use the :hash option i think
  
  
  #doulbe check the seecurity of using the s3 urls rather than cloudfront...what's the difference there?
  has_attached_file :image, 
  :storage => :s3,
  :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
  :path => ":class/:attachment/:id/:style_:basename.:extension",
  :bucket => 'rails3_production',
  :styles => {:full => "400x400", :inner => "200x200", :thumb => "50x50"}, 
  :processors => [:cropper] 
  #:storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml", :bucket => "rails3_development" 

  def update_mugshot_count
    
    self.authuser.mugshot_count = self.authuser.mugshots.count
    self.authuser.last_mugshot = self.id
    self.authuser.save
  end
  def try_image(size="full")
    #this is a placeholder method while the migration of the Mugshots db is moving over...delete when done
    if self.image.to_s.match("missing").class != NilClass
      f = AWS::S3.new.buckets[:dailymugshotprod].objects[self.filename].url_for(:read).open
      self.image = f
      self.save
      f.close
    end
    return self.image size.to_sym
    
  end
  
  
  def do_social
    # #after_create
    # #check for social connections and post / do whatever accordingly
    # if self.authuser.tweeting?
    #   @authuser = self.authuser
    #   self.authuser.twitter_connect.tweet("#{@authuser.login} just took #{@authuser.gender_possessive} #{@authuser.mugshots.count.ordinalize} mugshot at www.dailymugshot.com!")
    # end
  end
end
