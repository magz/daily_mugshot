class AuthusersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create, :index, :search, :show, :signup, :submit_forgot_password]
  
  # GET /authusers
  # GET /authusers.json
  def index
    @page_size = 12
    @current_page = params[:page] == nil ? 0 : params[:page].to_i
    if @current_page < 0
      @current_page = 0
    end
    #this could maybe be slightly more efficient
    @authusers = []
    # ((Mugshot.count - (@current_page +1)*@page_size)..(Mugshot.count - (@current_page)*@page_size)).each do |x|
    #   @authusers << Mugshot.find(x).authuser
    # end
    size=Mugshot.count
    while @authusers.count < @page_size
      temp = Mugshot.find(rand size)
      if temp.image_file_name != nil && temp.authuser != nil
        @authuser << temp.authuser
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authusers }
    end
  end
  def search
    #this could maybe be slightly better, but it works...was having some odd problems in nil result cases on the search
    @authusers = []
    b = Authuser.where(:prvt => false, :active => true, :login => params[:search_criteria])
    @authusers << b
    b = Authuser.where(:prvt => false, :active => true, :email => params[:search_criteria])
    @authusers << b
    @authusers.flatten!
    @authusers.each do |user|
      unless user.mugshots.count
        @authusers.delete user 
      end
    end
    @authusers.sort!{|a,b| a.last_mugshot_date <=> b.last_mugshot_date}
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authusers }
    end
    
  end
  # GET /authusers/1
  # GET /authusers/1.json
  def show
    @authuser = Authuser.find(params[:id]) || Authuser.find_by_login(params[:id])    
    #is this necessary?  for the mobile app maybe?
    raise(ActiveRecord::RecordNotFound,"Couldn't find Authuser with ID=#{params[:id]}") if @authuser.nil?
    #original has it include userstats with this..i'm guessing so it can do that thumbnail trick
    #leaving it off for the moment
    @comments = Comment.where(:authuser_id => @authuser).order("created_at DESC")
    if params[:current_tab] == "mosaic"
      @current_tab = "mosaic"
      @mugshots = @authuser.mugshots.where(:active => true).sort{|a,b| a.created_at <=> b.created_at}
    else
      @current_tab = "mugshow"
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @authuser }
    end
  end
  
  def show_mine
    @authuser = current_authuser
    unless @authuser == nil || !@authuser.has_mugshot?
      @page_size = 7
      @page_count = (@authuser.mugshots.count.to_f / @page_size.to_f).ceil
      if params[:page] != nil
        @current_page = params[:page].to_i
        if @current_page < 0
          @current_page = 0
        end
        if @current_page > @page_count
          @current_page = @page_count
        end
        if @current_page * @page_size == @authuser.mugshots.count
          @current_page -= 1
        end
        @mugshots = @authuser.mugshots[@current_page * @page_size..(@current_page * (@page_size +1)-1)].reverse
    
      else
        if params[:focused_mugshot] != nil
          @focused_mugshot = Mugshot.find(params[:focused_mugshot].to_i)
          ind=@authuser.mugshots.index @focused_mugshot
          @current_page = (@authuser.mugshots.count.to_f / ind).ceil
        
      
        else
          @current_page = 0
        end
      end
    
    
    
      @mugshots = @authuser.mugshots[@current_page * @page_size..(@page_size * (@current_page +1)-1)].reverse
      @focused_mugshot ||= @mugshots.first
    
    
      # if params[:page] != nil
      #   if params[:page].to_i < 0
      #     params[:page] = 0
      #   end
      #   if params[:page].to_i > @page_count
      #     params[:page] = @page_count
      #   end
      #   @current_page = params[:page].to_i
      #   if @current_page == @page_count && @authuser.mugshots.count % @page_size == 0
      #     @current_page -= 1
      #   end
      #   @mugshots = @authuser.mugshots[@current_page * @page_size..((@current_page + 1)*@page_size)-1].reverse
      #   @focused_mugshot = @mugshots.first
      # else  
      #   if params[:focused_mugshot]
      #     @focused_mugshot = Mugshot.find params[:focused_mugshot]
      #   else
      #     @focused_mugshot = @authuser.mugshots.last
      #   end
      #   ind=@authuser.mugshots.index(@focused_mugshot)
      #   @current_page = (ind.to_f / @authuser.mugshots.count.to_f).floor
      #   @mugshots = @authuser.mugshots[ind-@page_size..ind].reverse   
      #   
      # end
      # @page_count = (@authuser.mugshots.count.to_f / @page_size.to_f).ceil
      #@comments = Comment.where(:authuser_id => @authuser).order("created_at DESC")
      #might need to make sure this is ordered by date
    
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @authuser }
      end
    else
      flash[:notice] = "You'll need to take a picture first!"
      
      redirect_to :first_pic
    end
  end
  # GET /authusers/new
  # GET /authusers/new.json
  def signup
    @authuser = Authuser.new
    #email reminder
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @authuser }
    end
  end

  # GET /authusers/1/edit
  def edit
    @authuser = Authuser.find(current_authuser)
  end

  # POST /authusers
  # POST /authusers.json
  def create
    @authuser = Authuser.new(params[:authuser])
    
    @authuser.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{@authuser.login}--")
    @authuser.crypted_password =  Authuser.encrypt(params[:password], @authuser.salt)
    
    

    respond_to do |format|
      if @authuser.save
        session[:authuser] = @authuser.id
        format.html { redirect_to :new_pic, notice: 'Authuser was successfully created.' }
        format.json { render json: @authuser, status: :created, location: @authuser }
      else
        format.html { render action: "signup" }
        format.json { render json: @authuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /authusers/1
  # PUT /authusers/1.json
  def update
    #i think this should work other than the validation not being in there yet
    #also set up the routes for all these calls!
    @authuser = current_authuser
    #validate!!!
      #done below, but make sure it works!
    
    
    #@authuser.login_was = @authuser.login
    #what is the point of the above line?
    
    
    if @authuser && Authuser.authenticate(@authuser.login, params[:authuser][:old_password]) && @authuser.update_attributes(params[:authuser])
      respond_to do |format|
        format.html do
          flash[:notice] = "Your account has been updated."
          redirect_to my_mugshow_url
        end
        format.xml{ head :ok }
      end
    else
      respond_to do |format|
        format.html{ render :edit }
        format.xml{ render :xml => @authuser.errors.to_xml, :status => :unprocessable_entity }
      end
      
    end
  end

  # DELETE /authusers/1
  # DELETE /authusers/1.json
  def destroy
    @authuser = Authuser.find(params[:id])
    @authuser.destroy

    respond_to do |format|
      format.html { redirect_to authusers_url }
      format.json { head :ok }
    end
  end
  
  def submit_forgot_password
    #i think this is all pretty good...just gotta get that emailer up and running
    @authuser = Authuser.find_by_email(params[:email])
    if @authuser
      #generates a random alphanumeric sequence of 8 characters...old way was unnecessarily elaborate
      new_password = (0..8).map{ rand(36).to_s(36) }.join
      UserMailer.forgot_password(@authuser, new_password).deliver
      @authuser.crypted_password = Authuser.encrypt(new_password, @authuser.salt)
      @authuser.save
          respond_to do |format|
            format.html do
              flash[:notice] = "Success! Your password was reset and emailed to #{@authuser.email}"
              redirect_to :root
            end
            format.xml { head :ok }
          end
        else
          @error_messages = "Sorry, we could not find your email. Please try again."
          respond_to do |format|
            format.html { render :action => :forgot_password }
            format.xml  { render :xml => {:message => @error_messages}, :status => :unprocessable_entity }
          end
        end
    end

    def forgot_password
      
    end
    def update_privacy
      @user = Authuser.find params[:user]
      @user.prvt = params[:state]
      @user.save
        #flash[:notice] = 'Sequence was successfully updated.'
        respond_to do |format|
          #format.html { redirect_to :action => 'show', :id => @user.id }
          format.js
          format.xml { head :ok }
        end
    end
    
end


