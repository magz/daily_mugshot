class Mugshot < ActiveRecord::Base
  belongs_to :authuser
  has_many :comments
  validates :authuser, :presence => true


  #cropper is a custom processor
  #it takes in the xoffset and yoffset and does cropping accordingly
  
  #i think this is set up correctly but double check it
  has_attached_file :image, 
  :storage => :s3,
  :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
  :path => ":class/:attachment/:id/:style_:basename.:extension",
  :bucket => 'rails3_production',
  :styles => {:full => "400x400", :inner => "200x200", :thumb => "50x50"}, 
  :processors => [:cropper] 
  #:storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml", :bucket => "rails3_development" 

  def try_image(size)
    if self.image.to_s.match "missing" == nil
      self.image = AWS::S3.new.buckets[:dailymugshotprod].objects[self.filename].url_for(:read).open
      self.save
    end
    return self.image size
    
  end
  def download(download_path)
    
  end
  
  def self.populate_images
    Mugshot.where(:transfer_error => nil, :image_file_name => nil).limit(10000).each do |m|
      begin
        id_s = m.id.to_s
        m.image =open ("http://www.dailymugshot.com/secret_photo_fetch/" + id_s )
        m.save
        puts id_s + "was saved successfully"
      rescue
        begin
          puts id_s + "DID NOT SAVE!*!^*!*!"
          m.image = NULL
          m.transfer_error = true
          m.save
          
        rescue
        end
      end  
  end
end
  def populate_image
    begin
      id_s = self.id.to_s
      self.image =open ("http://www.dailymugshot.com/secret_photo_fetch/" + id_s )
      self.save
      puts id_s + "was saved successfully"
    rescue
      begin
        puts id_s + "DID NOT SAVE!*!^*!*!"
        self.image = NULL
        self.transfer_error = true
        self.save
        
      rescue
      end
    end  
    
  end
  def s3_get_private_url
    if s3_connect?
      prv_url = Aws::S3::S3Object.url_for(self.filename,s3_config[:bucket_name])
      #todo: for some reason if I try to disconnect here it craps out with "http session not yet started"
      return prv_url
    else
      return nill
    end
  end
  def s3_connect?
    #get s3 config info
    s3_config = {bucket_name: "dailymugshotprod", access_key_id: "1Q65KGMYS9RGYG32XC02", secret_access_key: "HHaT7rS7VTcJ4s+j5SbN4p7+ZFMpgmT2ooDo4OBz"}
    
    #open S3 Connection
    unless Aws::S3::Base.connected?
      Aws::S3::Base.establish_connection!(  
        :access_key_id => s3_config[:access_key_id], 
        :secret_access_key => s3_config[:secret_access_key]
      )
    end                                     
    return AWS::S3::Base.connected?
  end
  
end
