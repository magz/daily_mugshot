class Video < ActiveRecord::Base
belongs_to :authuser
require 'net/http'

	def generate_self
		@errors = []
		tempfolder = File.join(Rails.root, "tmp", "video", self.authuser_id.to_s)
    begin
			FileUtils.rm_rf(tempfolder)
      Dir::mkdir(tempfolder)
		rescue
			@errors << "Directory already exists"
		end

		fetch_photos(tempfolder + "/")
		
		command = "cd " + tempfolder + " && ffmpeg -minrate 5000k -maxrate 5000k -bufsize 1835k -b 5000k -s 480x480 -f image2 -r 8 -i 'dms-%05d.jpeg' -qscale 1 output.flv"
		io = IO.popen(command)
      	io.each{|line| puts "ffmpeg says: " + line }
    
    description = "This video was created by " +self.authuser.login + " at dailymugshot.com using images from " + self.authuser.created_at.strftime("%m/%d/%Y") + " to " + Time.now.strftime("%m/%d/%Y")
    uploader = YouTubeIt::Client.new(username: 'dailymugshot', password: 'roebling909', dev_key: 'AI39si5FzQ55UvBK2Fb0c9uLJ-UHJco30YuEmhCc3HZwjIk668H3xmV5ZqWR1UcAgA0iK7YmwJ9y8A548DKft4_pmKDTh8_vSw') 
    result = uploader.video_upload File.open(tempfolder + "/output.flv"), :title => self.authuser.login, :description => description, :category => 'People',:keywords => %w[dailymugshot]
    
    FileUtils.rm_rf(File.join(Rails.root, "tmp", "video", self.authuser_id.to_s))
    return result.player_url
  end



  def fetch_photos(destination)
    #this is to create the pre roll...it simply copies the splash image 30 times (/10 frames per second = 3 secs.).  You can modify the length of the preroll by adjusting the "30" in the iterator below
    #slightly sloppy, but it ensures a smooth transition
    (0..25).each do |increment|
      filename = "%05d" % increment.to_s
      io = IO.popen("cp " + File.join(Rails.root, "app", "assets", "images", "videoPromo.jpg ") + destination + "dms-"+filename+".jpeg")
      io.each{|line| puts "result: " + line }
      
    end
    
    increment = 26
    
    self.authuser.mugshots.each do |m|
      begin
        url = m.try_image
        Net::HTTP.start(URI.parse(url).host) { |http|
          path = url
          path.slice!(URI.parse(url).scheme + "://" + URI.parse(url).host)
           resp = http.get(path)
          #should check here to make sure that resp is an image file...figure out best way to do that
          filename = "%05d" % increment.to_s
          open(destination + "dms-"+filename + ".jpeg", "wb") {|file|
            file.write(resp.body)
            }
          increment = increment + 1
        
        }
          end
      end  
  end

end
