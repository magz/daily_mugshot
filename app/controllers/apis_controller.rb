class ApisController < ApplicationController
  skip_before_filter :require_login
  
  #this is almost exclusively code for the flash objects
  #it integrates code from both the api and openapis controllers
  #as a result of it being based on some of the last remaining (yay!) legacy code, the functions here may be a bit wonky 
  #eventually i hope to replace the flash objects with html5/JS
  
  #there is seriously no reason why this is called api controller...either come up with a better name, or move these functions to controllers where they make sense
  
  #be careful with security on this
  def full_upload_get_api_paths
    @id = params[:id]
    respond_to do |format|
      format.xml 
    end

  end
  
  def get_sequence
      #verify we have a populated parameter
      unless FileTest.exists?("tmp/get_sequence_cache/" + params[:userid] + ".xml")
      
        if params[:userid] != nil
          #verify user
          user = Authuser.find(params[:userid])
          if user != nil     
            # if logged_in? && current_authuser.id == 60581 && FileTest.exists?("tmp/get_sequence_cache/" + user.id.to_s + ".xml")
            #   request.format = "xml"
            #   respond_with File.read(File.open("tmp/get_sequence_cache/" + user.id.to_s + ".xml"))
            #   return
            # else  
              @pics = user.mugshots
            # end
          else
            @pics = nil
          end
        else
          @pics = nil
        end
      #sorry there are some finer points of respond_to i'm missing
      #forgive me my ignorance if i don't make it back to fix this up
          request.format = "xml"
          respond_to do |format|
            format.xml
          end
      else
        logger.info "rendering user " + params[:userid] + " sequence from cache...."
        render :layout => false, :file => "tmp/get_sequence_cache/" + params[:userid] + ".xml"
        
      end
    
      
  end
  
  # def upload_file
  #   logger.info "ok this is the endpoint we're hitting"
  #   logger.info "---------------"
  #   if params['Filedata']
  #     if params[:userid] != nil
  #       @authuser = Authuser.find(params[:userid])
  #     end
  #     if request.remote_ip != "67.207.146.155" && @authuser == nil
  #      i=IpAddressHack.where(ip_address: request.remote_ip).last
  #       if i.created_at > Time.now - 5.minutes
  #         @authuser = Authuser.find(i.authuser)
  #         logger.info "matched ip address" + i.ip_address + "to user " + @authuser.id.to_s + "  login  " + @authuser.login
  #       else
  #         @authuser = nil
  #         logger.info "no matching ip address found"
  #       end
  #     end
  #     logger.info "ok"
  #     if @authuser
  #       logger.info @authuser.login + "is the authuser we're trying to upload an image for"
  #       m=Mugshot.new
  #       m.authuser_id = @authuser.id
  #       m.image = params["Filedata"].read
  #       #m.save
  #       
  #       logger.info params["Filedata"].class
  #     end
  #     
  #   end
  #   #i am neither sure if this is going to work or if it's actually used
  #   #i am, for example, not clear how this funciton relates to the primary upload funciton
  #   #or how it sets up which user is the uploader
  #   path = File.join(Rails.root, "public", "tmp")
  #   Dir.mkdir(path) unless Dir.entries(File.join(Rails.root, "public")).include? "tmp"
  #   fullpath = path + "/#{params['filename']}.jpg"
  #   `touch #{fullpath}`
  #   
  #   File.open(fullpath, "wb") do |f|
  #         f.write(params['Filedata'].read)
  #   end
  #     
  # end
  
  def get_landmarks
    #this is called by the fullupload object
    unless params[:userid] == nil
      #verify user exists and is the same as logged in user
      @authuser = Authuser.find(params[:userid])
      unless @authuser == nil 
          @landmarks = @authuser.landmarks
          # i=IpAddressHack.new
          # i.authuser_id = @authuser.id
          # i.ip_address = request.remote_ip
          # i.save
      else
        redirect_to :action => 'wrong_user'
      end
    end 
    #sorry there are some finer points of respond_to i'm missing
    #forgive me my ignorance if i don't make it back to fix this up
    request.format = "xml"
      
    respond_to do |format|
      format.xml  { render :layout => false }
    end
  end
  
  def get_full
    if params[:filename]
      @full = Mugshot.find(params[:filename])
    end
    request.format = "xml"
      respond_to do |format|
      format.xml  { render :layout => false }
    end
  
  
  end
  #this is based on the old method of keeping track of image files...we're not doing that anymore
  # def get_full
  #   if params[:filename] =~ /(open.+[\z^.*?])/ix 
  #     s = $1
  #     s = s.chop.chop
  #   end
  #   @authuser = Authuser.find params[:userid]
  #   @full = @authuser.mugshots.find_by_image_file_name s
  #   #sorry there are some finer points of respond_to i'm missing
  #   #forgive me my ignorance if i don't make it back to fix this up
  #   request.format = "xml"
  #   
  #   respond_to do |format|
  #     format.xml  { render :layout => false, :status => (@full ? :ok : 404) }
  #   end
  # end
  
  def set_inner
    #this is called by the adjust object to update the offset of a mugshot
    #this necessicates a recropping of the mugshot images i think
    #verify arguments
    unless (params[:userid] == nil) || (params[:filename == nil]) || (params[:xoffset] == nil) || (params[:yoffset] == nil)
      xoffset = params[:xoffset].to_i
      yoffset = params[:yoffset].to_i
      #verify the params are within range listed above
      unless (xoffset > 40) || (xoffset < -40) || (yoffset > 40) || (yoffset < -40)
        #verify user
        user = Authuser.find(params[:userid].to_i)
        unless user == nil #|| user.id != current_authuser.id
          if params[:filename] =~ /(open.+[\z^.*?])/ix 
            s = $1
            s = s.chop.chop
          end

          pic = Mugshot.find_by_image_file_name s
          #verify this picfull belongs to this user
          unless  pic == nil
            pic.xoffset = xoffset
            pic.yoffset = yoffset
            if pic.save
              #todo: create new picinner
              @returnstatus = 0
            else
              @returnstatus = 5 # trouble saving pics
            end
          else
            @returnstatus = 4 #pic not found for given user
          end
        else
          @returnstatus = 3 # user not found or user id does not match signed in user
        end
      else
        @returnstatus = 2 # offsets are out of range
      end
    else
      @returnstatus = 1 # post arguments missing
    end
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end
  def get_update
    #i think i can probably integrate this into my new update function
    #get new update for the alert box
    @header = "New Mugshot!"
    new_mug = Mugshot.last
    unless new_mug
      render :nothing => true
      return
    end

    @authuser = new_mug.authuser

    pic_num = @authuser.mugshots.count.ordinalize

    gender = @authuser.gender == "m" ? "his" : "her"

    @description = @authuser.login + " just took "+ gender + " " + pic_num + " mugshot!"

    @image_url = new_mug.try_image "thumb"
    #change this to adapt with the host via request.host and maybe request.port
    @new_url = "http://localhost:3000"

    #css class
    @class = "new_mugshot"

    #identifier
    @identifier = @authuser.id.to_s + pic_num

    # render :layout => false
    #response =  {:header => @header, :authuser => @authuser, :gender => gender, :description => @description, :image_url => @image_url, :class => @class} 
    respond_to do |format|
    format.html { render :layout => false }
    format.json { render json: @authuser }
    format.js
    end
    end

    def new_get_sequence
      #updating of get_sequence call for new data models...not used atm
    @result = []
    @authuser = Authuser.find(params[:authuser])
    @result << @authuser.id
    @authuser.mugshots.each do |pic|
      @result << pic.try_image("inner")
    end 
    # temp = Mugshot.where(:authuser_id => params[:authuser]).sort! {|a,b| a.created_at <=> b.created_at}
    # temp.each do |shot|
    #   @mugshots << shot.image(:inner) 
    # end
    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @result }
      format.js
    end
    end
    def upload
      #this is the real upload function for both mobile and web...impt!
      #this is i think the function for both the flash object and mobile uploading
      #impt impt impt
      #i think this should be working
      #make sure we did not already take a picture today.
      
      logger.info request.remote_ip 
      logger.info "that ip just tried to upload something"
      if params[:userid] != nil
        @authuser = Authuser.find(params[:userid])
      end

      #yeah, so this bit is super hacky and (hopefully) temporary
      #the gist of it is this: the seesion doesn't seem to be available (when this is accessd by fullupload.swf) because this is a reqest from a flash object, not the user
      #the real answer here would be to modify the flash object, but, unfortunately, someone lost the .fla somewhere along the line
      #as i have no desire to learn flash, this is what we're left with
      #every time a user access /new_pic, an IpAddressHack model is generated, pairing their ip address to the user id
      #when we come here, it's checked if there's a recent ip address object, and pulls the auth id from that
      #the danger here is that you have 2 users with the same ip address both accessing within a short time
      #no solution for that so here we are
      #may god have mercy on my soul

      #o and ps 67.207.146.155 is the load balancer...this is also the reason i took off the load balancer
      #with it in place, every IP was showing up as being that ip address, rather than the actual users
      #so yeah, this workaround necessitates killing the load balancer...o wells

      if request.remote_ip != "67.207.146.155" && @authuser == nil
       i=IpAddressHack.where(ip_address: request.remote_ip).last
        if i.created_at > Time.now - 5.minutes
          @authuser = Authuser.find(i.authuser)
          logger.info "matched ip address" + i.ip_address + "to user " + @authuser.id.to_s + "  login  " + @authuser.login
        else
          @authuser = nil
          logger.info "no matching ip address found"
        end
      end
      unless @authuser == nil 
        @returnstatus = 0
        unless params["method"] == nil
          #to do: rewrite this so it's not actually writing the file...that's mad stupid
          if params["method"] == "webcam" 
            if params["bindata"] != nil
              decoded = Base64.decode64 params["bindata"]
              #I...can't say i like this random thing...it'd be better if it was more programattic
              filename = "snapshot" + rand(100000).to_s + ".jpg"
              full_path = File.join(Rails.root, "tmp", "uploads",  filename)
              Dir.mkdir('tmp/uploads') unless Dir.entries('tmp').include?('uploads')
              `touch #{full_path}`
              f=File.open full_path, "wb"
              f.write decoded
            else
              @returnstatus = 1
              @msg = "no image info"
            end
          elsif params["method"] == "file"
            if params["filename"] == nil
              @returnstatus = 1
              @msg = "undefined filename"
            else
              full_path = File.join(Rails.root, "public","tmp", params["filename"])
            end
          else
            @returnstatus = 1
            @msg = "undefined method"
          end
        end

        if @returnstatus == 0
          m=Mugshot.new
          m.caption = params["caption"] #== nil ? nil : params["caption"].gsub(/[^A-Za-z0-9_\s\?\(\)\!\.\,]/,'').chomp!
          m.xoffset = params["xoffset"].to_i
          m.yoffset = params["yoffset"].to_i
          m.image =  File.open(full_path)
          `rm #{full_path}`
          m.authuser_id = @authuser.id
          #do _we_ really need all that complicated return status stuff?  Can i just give them an up or down?
          #make sure save happened and give returnstatus accordingly
          m.save
          if FileTest.exists?("tmp/get_sequence_cache/" + @authuser.id.to_s + ".xml")
            `rm "tmp/get_sequence_cache/" + @authuser.id.to_s + ".xml"`
          
          end
          do_social(@authuser)
          
          @msg = @returnstatus
          #do social networking push
        end
      else
          @returnstatus = 1
          @msg = "already taken image today"
      end
      request.format = "xml"
      respond_to do |format|
        format.xml { render :layout => false }
      end
    end
  def get_multi_box_update
    #this is my new ajax call for the front page..magz
    @mugshot = Mugshot.last(50).shuffle.last
    @authuser = @mugshot.authuser
    gender = @authuser.gender == "m" ? "his" : "her"
    @hash = {image: @mugshot.try_image("inner"), userid: @authuser.id, message: (@authuser.login + " just took " + gender + " " + @authuser.mugshots.count.ordinalize + " mugshot!")}
    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @hash }
      format.js
    end
  end
  def alarm
      #this is the alarm for the desktop alerter
      #probably not all done up for time zones yet
      unless params[:user] == nil
        #verify user
        @user = Authuser.find_by_login(params[:user])
        unless @user == nil     
          @last = @user.mugshots.last
          @pic_count = @user.mugshots.count
          redirect_to :action => 'firstalarm' and return if @pic_count == 0
  
          #implement this model
          @mac_version = "1.0"
          @win_version = "0.9.0"
          @protocol_version = "1.0"
          #update userstats
          #userstat = Userstat.find_by_authuser_id @user.id
          #does this do anything?
          # unless userstat == nil
          #   userstat.last_alarm = Time.new.gmtime
          #   userstat.alarm_version = params[:cversion] == nil ? "unknown" : params[:cversion].gsub(/[^A-Za-z0-9_\s\.]/,'')
          #   userstat.save
          # end 
        else
          redirect_to :action => 'user_not_found' and return
        end
      else
        redirect_to :action => 'require_login' and return
      end
      request.format = "xml"
      respond_to do |format|
        format.xml
      end
    end
    
  #no clue what this is about...i guess look in the old code and see what it was doing...probably something that can be done in one func though
  def firstalarm
    render xml: nil
  end
  
  def do_social(authuser)
    logger.info "begging social for " + authuser.login
    if authuser.tweeting?
      pic_num = authuser.mugshots.count.ordinalize
  
      gender = authuser.gender == "m" ? "his" : "her"
      
      description = authuser.login + " just took "+ gender + " " + pic_num + " mugshot!  www.dailymugshot.com/" + authuser.id.to_s
      logger.info "tweeting for " + authuser.login
      authuser.twitter_connect.tweet description
          
    end
    
    
  end  
  
  
end

