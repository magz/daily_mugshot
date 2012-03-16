class Mugshot < ActiveRecord::Base
  belongs_to :authuser
  has_many :comments
  
  validates :authuser, :presence => true

  #after_create :do_social
  # after_create :authuser_mugshot_info_update
  #cropper is a custom processor
  #it takes in the xoffset and yoffset and does cropping accordingly
  
  #in the refactored code this is THE configuration that determines the handling of the images
  #if you want to modify it, probably look here
  #the previous code di tons of overriding of the paperclip methods
  #this was the source of a tremendous amounts of its messiness
  #if you want to obscure the urls of the mugshots, use the :hash option i think
  
  after_create :update_users_mugshot_stats, :do_social
  
  
  #doulbe check the seecurity of using the s3 urls rather than cloudfront...what's the difference there?
  has_attached_file :image, 
  :storage => :s3,
  :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
  :path => ":class/:attachment/:id/:style_:basename.:extension",
  :bucket => 'rails3_production',
  :styles => {:full => "400x400", :inner => "200x200", :thumb => "50x50"}, 
  :processors => [:cropper] 
  #:storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml", :bucket => "rails3_development" 

  def cloudfront_url( variant = nil )
    image.url(variant).gsub( "http://s3.amazonaws.com/rails3_production", "http://d3i7412iuyx9g1.cloudfront.net" )
  end
  
  def try_image(size="full")
    #this is a placeholder method while the migration of the Mugshots db is moving over...delete when done
    if self.image.to_s.match("missing").class != NilClass
      #f = AWS::S3.new.buckets[:dailymugshotprod].objects[self.filename].url_for(:read).open
      return AWS::S3.new.buckets[:dailymugshotprod].objects[self.filename].url_for(:read).to_s
      #self.image = f
      #self.save
      #f.close
    end
    return self.cloudfront_url(size.to_sym)
    
  end
  
  def update_users_mugshot_stats
    self.authuser.save
  end
  #below are also attempts at populator methods...not necessary and to be deleted
  

  
  def do_social
    # #after_create
    # #check for social connections and post / do whatever accordingly
    # if self.authuser.tweeting?
    #   @authuser = self.authuser
    #   self.authuser.twitter_connect.tweet("#{@authuser.login} just took #{@authuser.gender_possessive} #{@authuser.mugshots.count.ordinalize} mugshot at www.dailymugshot.com!")
    # end
  end
end
