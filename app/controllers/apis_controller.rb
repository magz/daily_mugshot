class ApisController < ApplicationController
  skip_before_filter :require_login
  #this is almost exclusively code for the flash objects
  #it integrates code from both the api and openapis controllers
  #as a result of it being based on some of the last remaining (yay!) legacy code, the functions here may be a bit wonky 
  #eventually i hope to replace the flash objects with html5/JS
  
  #holy god, i can't believe this is necessary
  #short version: stupid upload flash obj doesn't pass userid
  #i api/upload used to be able to get the userid from the session, but at least now it can't (really not sure how it ever worked)
  #so what this is doing is generating a path to api/upload that contains within it the userid, so it's passed that way
  #if you're looking at this and not named magz, i know, it's insane...gimme an email at michael.magner@gmail.com and i'll try to walk you through it
  def full_upload_get_api_paths
    @id = params[:id]
    respond_to do |format|
      format.xml 
    end

  end
  #be careful with security on this
  def get_sequence
    #verify we have a populated parameter
    if params[:userid] != nil
      #verify user
      user = Authuser.find(params[:userid])
      if user != nil     
        @pics = Mugshot.where(:authuser_id => params[:userid])
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
  end
  
  def upload_file
  
    #i am neither sure if this is going to work or if it's actually used
    #i am, for example, not clear how this funciton relates to the primary upload funciton
    #or how it sets up which user is the uploader
    path = File.join(Rails.root, "public", "tmp")
    Dir.mkdir(path) unless Dir.entries(File.join(Rails.root, "public")).include? "tmp"
    fullpath = path + "/#{params['filename']}.jpg"
    `touch #{fullpath}`
    
    File.open(fullpath, "wb") do |f|
          f.write(params['Filedata'].read)
    end
      
  end
  
  def get_landmarks
    #this is called by the fullupload object
    unless params[:userid] == nil
      #verify user exists and is the same as logged in user
      @authuser = Authuser.find(params[:userid])
      unless @authuser == nil 
          @landmarks = @authuser.landmarks
          
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
      @authuser = Authuser.first
      unless @authuser.already_taken_today?
        @returnstatus = 0
        unless params["method"] == nil
          if params["method"] == "webcam" 
            if params["bindata"] != nil
              decoded = Base64.decode64 params["bindata"]
              #I...can't say i like this random thing...it'd be better if it was more programattic
              filename = "snapshot" + rand(100000).to_s + ".jpg"
              full_path = File.join(Rails.root, "tmp", "uploads",  filename)
              Dir.mkdir('tmp/uploads') unless Dir.entries('tmp').include?('uploads')
              #can you do this?  do you not need to use cocaine to do this sort of commandline ju jitsu?
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
          m.caption = params["caption"] == nil ? nil : params["caption"].gsub(/[^A-Za-z0-9_\s\?\(\)\!\.\,]/,'').chomp!
          m.xoffset = params["xoffset"].to_i
          m.yoffset = params["yoffset"].to_i
          m.image =  File.open(full_path)
          `rm #{full_path}`
          m.authuser_id = @authuser
          #do _we_ really need all that complicated return status stuff?  Can i just give them an up or down?
          #make sure save happened and give returnstatus accordingly
          m.save
          @msg = @returnstatus
          #do social networking push
        end
      else
          @returnstatus = 1
          @msg = "already taken image today"
      end
      respond_to do |format|
        format.xml { render :layout => false }
      end
    end
    def upload_with_id
    #this is the real upload function for both mobile and web...impt!
    #this is i think the function for both the flash object and mobile uploading
    #impt impt impt
    #i think this should be working
    #make sure we did not already take a picture today.
    @authuser = Authuser.find(params[:id])
    unless @authuser.already_taken_today?
      @returnstatus = 0
      unless params["method"] == nil
        if params["method"] == "webcam" 
          if params["bindata"] != nil
            decoded = Base64.decode64 params["bindata"]
            #I...can't say i like this random thing...it'd be better if it was more programattic
            filename = "snapshot" + rand(100000).to_s + ".jpg"
            full_path = File.join(Rails.root, "tmp", "uploads",  filename)
            Dir.mkdir('tmp/uploads') unless Dir.entries('tmp').include?('uploads')
            #can you do this?  do you not need to use cocaine to do this sort of commandline ju jitsu?
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
        m.caption = params["caption"] == nil ? nil : params["caption"].gsub(/[^A-Za-z0-9_\s\?\(\)\!\.\,]/,'').chomp!
        m.xoffset = params["xoffset"].to_i
        m.yoffset = params["yoffset"].to_i
        m.image =  File.open(full_path)
        `rm #{full_path}`
        m.authuser_id = @authuser
        #do _we_ really need all that complicated return status stuff?  Can i just give them an up or down?
        #make sure save happened and give returnstatus accordingly
        m.save
        @msg = @returnstatus
        #do social networking push
      end
    else
        @returnstatus = 1
        @msg = "already taken image today"
    end
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end

  def get_multi_box_update
    #this is my new ajax call for the front page..magz
    @mugshot = Mugshot.where("image_file_name != 'nil'").last
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
        @last = @user.mugshost.last
        @pic_count = @user.mugshots.count
        redirect_to :action => 'firstalarm' and return if @pic_count == 0

        #implement this model
        @mac_version = Reminder.find_by_platform('mac', :order => "created_at DESC").version
        @win_version = Reminder.find_by_platform('win', :order => "created_at DESC").version
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
    respond_to do |format|
      format.xml
    end
  end
  
  
end

