class Mugshot < ActiveRecord::Base
  belongs_to :authuser
  has_many :comments
  
  validates :authuser, :presence => true

  after_create :do_social

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
  
  #below are also attempts at populator methods...not necessary and to be deleted
  
#   def self.populate_images
#     Mugshot.where(:transfer_error => nil, :image_file_name => nil).limit(10000).each do |m|
#       begin
#         id_s = m.id.to_s
#         m.image =open ("http://www.dailymugshot.com/secret_photo_fetch/" + id_s )
#         m.save
#         puts id_s + "was saved successfully"
#       rescue
#         begin
#           puts id_s + "DID NOT SAVE!*!^*!*!"
#           m.image = NULL
#           m.transfer_error = true
#           m.save
#           
#         rescue
#         end
#       end  
#   end
# end
#   def populate_image
#     begin
#       id_s = self.id.to_s
#       self.image =open ("http://www.dailymugshot.com/secret_photo_fetch/" + id_s )
#       self.save
#       puts id_s + "was saved successfully"
#     rescue
#       begin
#         puts id_s + "DID NOT SAVE!*!^*!*!"
#         self.image = NULL
#         self.transfer_error = true
#         self.save
#         
#       rescue
#       end
#     end  
#     
#   end
  
  # def s3_get_private_url
  #   if s3_connect?
  #     prv_url = Aws::S3::S3Object.url_for(self.filename,s3_config[:bucket_name])
  #     #todo: for some reason if I try to disconnect here it craps out with "http session not yet started"
  #     return prv_url
  #   else
  #     return nill
  #   end
  # end
  # def s3_connect?
  #   #get s3 config info
  #   s3_config = {bucket_name: "dailymugshotprod", access_key_id: "1Q65KGMYS9RGYG32XC02", secret_access_key: "HHaT7rS7VTcJ4s+j5SbN4p7+ZFMpgmT2ooDo4OBz"}
  #   
  #   #open S3 Connection
  #   unless Aws::S3::Base.connected?
  #     Aws::S3::Base.establish_connection!(  
  #       :access_key_id => s3_config[:access_key_id], 
  #       :secret_access_key => s3_config[:secret_access_key]
  #     )
  #   end                                     
  #   return AWS::S3::Base.connected?
  # end
  
  def do_social
    #after_create
    #check for social connections and post / do whatever accordingly
    if self.authuser.tweeting?
      @authuser = self.authuser
      self.authuser.twitter_connect.tweet("#{@authuser.login} just took #{@authuser.gender_possessive} #{@authuser.mugshots.count.ordinalize} mugshot at www.dailymugshot.com!")
    end
  end
end
