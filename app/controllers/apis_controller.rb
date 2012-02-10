class ApisController < ApplicationController
  #this is almost exclusively code for the flash objects
  #it integrates code from both the api and openapis controllers
  #as a result of it being based on some of the last remaining (yay!) legacy code, the functions here may be a bit wonky 
  #eventually i hope to replace the flash objects with html5/JS
  
  
  #be careful with security on this
  def get_sequence
    #verify we have a populated parameter
    Rails.logger.info "bam"
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
    respond_to do |format|
      format.xml
      format.json  { render :json => @pics }
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
    unless params[:userid] == nil
      #verify user exists and is the same as logged in user
      @authuser = Authuser.find(params[:userid])
      unless @authuser == nil 
          @landmarks = @authuser.landmarks
      else
        redirect_to :action => 'wrong_user'
      end
    end   
    respond_to do |format|
      format.xml  { render :layout => false }
    end
  end


  def get_full
    if params[:filename] =~ /(open.+[\z^.*?])/ix 
      s = $1
      s = s.chop.chop
    end
    @authuser = Authuser.find params[:userid]
    @full = @authuser.mugshots.find_by_image_file_name s
    respond_to do |format|
      format.xml  { render :layout => false, :status => (@full ? :ok : 404) }
    end
  end
  
  def set_inner
    #what's it trying to do here?
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

    @image_url = new_mug.image :thumb
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
    @result = []
    @authuser = Authuser.find(params[:authuser])
    @result << @authuser.id
    @authuser.mugshots.each do |pic|
      @result << pic.image(:inner)
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
  def get_multi_box_update
    @mugshot = Mugshot.where("image_file_name != 'nil'").last
    @authuser = @mugshot.authuser
    gender = @authuser.gender == "m" ? "his" : "her"
    @hash = {image: @mugshot.image(:inner), userid: @authuser.id, message: (@authuser.login + " just took " + gender + " " + @authuser.mugshots.count.ordinalize + " mugshot!")}
    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @hash }
      format.js
    end
  end
  def alarm
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

