class AuthusersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create, :index, :search, :show, :signup, :forgot_password, :submit_forgot_password, :submit_forgot_password, :create_comment, :ajax_get_friends, :ajax_get_comments, :ajax_switch_to_mosaic]
  before_filter :privacy_filter, :only => [:show]
  
  def create_comment
    if params[:authuser_id].to_i == current_authuser.id
      @comment = Comment.new
      @comment.body = params[:comment][:body]
      @comment.authuser_id = params[:authuser_id]
      @comment.owner_id = params[:owner_id]
    end
    
    respond_to do |format|
      if @comment.save
        @comments = Comment.where(owner_id: params[:owner_id]).order("created_at DESC")        #format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        #format.json { render json: @comment, status: :created, location: @comment }
        format.js do 
          template_format = :html
          @comment_html = render_to_string(:partial=>'comments.html.erb', :layout => false, :locals => {:comments => @comments}).html_safe
          render :json => { :success => true, :user_html => @comment_html  }

        end
      else
        #format.html { render action: "new" }
        #format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js
        
      end
    end
  end
  
  def ajax_switch_to_mosaic
    @authuser  = Authuser.find_by_id(params[:id])
    if @authuser
      @mugshots = @authuser.mugshots
      
      
      
      
      template_format = :html
      @mosaic_html = render_to_string(:partial=>'mosaic_view.html.erb', :layout => false, :locals => {:mugshot => @mugshots}).html_safe
      render :json => { :success => true, :mosaic_view_html => @mosaic_html  }
      
    end
  
  
  end
  
  def ajax_get_friends
    @authuser  = Authuser.find_by_id(params[:id])
    if @authuser
      @followed_friends = []
      @following_friends = []
      Friendship.where(:followee_id => @authuser.id).each do |f|
        begin
          if Authuser.find(f.authuser_id) != nil
            @following_friends << f.authuser
          end
        rescue
        end
      end
      Friendship.where(:authuser_id => @authuser.id).each do |f|
        begin
          if Authuser.find(f.authuser_id) != nil
            @followed_friends << f.followee
          end
        rescue
        end
      end
      # format.js do 
        template_format = :html
        @friends_html = render_to_string(:partial=>'friends.html.erb', :layout => false, :locals => {:comments => @comments}).html_safe
        render :json => { :success => true, :friends_html => @friends_html  }

      # end
      
  
    end
  end
  def ajax_get_comments
    logger.info "ok we're in ajax get comments now..."
    
    @authuser  = Authuser.find_by_id(params[:id])
    if @authuser
      @comments = Comment.where(owner_id: @authuser.id).order("created_at DESC")
        
    end
      # format.js do 
        template_format = :html
        @comments_html = render_to_string(:partial=>'comments.html.erb', :layout => false, :locals => {:comments => @comments}).html_safe
        render :json => { :success => true, :comments_html => @comments_html  }
  
      # end
  #     
  # 
  end
  
  
  
  def privacy_filter
    if params[:id].to_i.to_s == params[:id]
      @authuser = Authuser.find(params[:id]) 
    else
      @authuser = Authuser.find_by_login(params[:id]) 
    end 
    if @authuser != nil && @authuser.prvt == true 
      unless logged_in? && @authuser.id == current_authuser.id
        flash[:notice] = "We're sorry, but that account is private"
        redirect_to :root
      end
    end
  end
  # GET /authusers
  # GET /authusers.json
  def index
    #this could maybe be slightly more efficient
    @authusers = Authuser.where("mugshot_count > 10 AND last_mugshot is not null").order("RAND()").paginate(:page => params[:page])
    @mugshots = []
    @authusers.each do |a|
      @mugshots << Mugshot.find(a.get_last_mugshot)
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
    if @authusers != []
      if @authusers.size > 1
        @authusers.sort!{|a,b| a.last_mugshot_date <=> b.last_mugshot_date}
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @authusers }
        end
      else
        redirect_to "/authusers/" + @authusers[0].id.to_s
      end
    else
      flash[:notice] = "Sorry, no results were found for your search"
      redirect_to :root
    end
  end
  # GET /authusers/1
  # GET /authusers/1.json
  def show
    logger.info params[:id] + "this is the user currently being looked up....."
    if params[:id].to_i.to_s == params[:id]
      @authuser = Authuser.find(params[:id]) 
    else
      @authuser = Authuser.find_by_login(params[:id]) 
    end 
    if @authuser == nil
      flash[:notice] = "Sorry that user wasn't found!"
      redirect_to :root
      return
    end
    
    @comments = Comment.where(owner_id: @authuser.id).order("created_at DESC")
    @new_comment = Comment.new
    # @followed_friends = []
    # @following_friends = []
    # Friendship.where(:followee_id => @authuser.id).each do |f|
    #   begin
    #     if Authuser.find(f.authuser_id) != nil
    #       @following_friends << f.authuser
    #     end
    #   rescue
    #   end
    # end
    # Friendship.where(:authuser_id => @authuser.id).each do |f|
    #   begin
    #     if Authuser.find(f.authuser_id) != nil
    #       @followed_friends << f.followee
    #     end
    #   rescue
    #   end
    # end
    if params[:current_tab] == "mosaic"
      @current_tab = "mosaic"
      #add a thing to only get active ones
      @mugshots = @authuser.mugshots.sort{|a,b| a.created_at <=> b.created_at}
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
    if @authuser.has_mugshot?
      @mugshots = @authuser.mugshots
      @focused_mugshot = @mugshots.first
    
    
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @authuser }
      end
    else
      flash[:notice] = "You'll need to take a picture first!"
      
      redirect_to :first_pic
    end
  end

  def signup
    @authuser = Authuser.new
    @errors ||= []
    respond_to do |format|
      format.html 
      format.json { render json: @authuser }
    end
  end

  # GET /authusers/1/edit
  def edit
    @authuser = current_authuser
    @errors = []
  end
  

  # POST /authusers
  # POST /authusers.json
  def create
    @authuser = Authuser.new()
    @errors = []
    
    if params[:authuser][:password] == params[:authuser][:password_confirmation] && params[:authuser][:password] != ""
      @authuser.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{@authuser.login}--")
      @authuser.crypted_password =  Authuser.encrypt(params[:authuser][:password].strip, @authuser.salt)
    else
      if params[:authuser][:password] == "" 
        @errors << "You cannot leave your password blank"
      else
        @errors << "Your password and password confirmation didn't match"
      end
    end
    
    unless params[:authuser][:email]
      @errors << "You left your email blank!"
    end
    
    unless params[:authuser][:time_zone]
      @errors << "You left your time_zone blank!"
    end
    
    unless params[:authuser][:login]
      @errors << "You left your login blank!"
    end
    
    unless params[:authuser][:gender]
      @errors << "You left your gender blank!"
    end

    unless Authuser.find_by_email(params[:authuser][:email]) == nil
      @errors << "Sorry, but you've already used that email address!"
    end
    
    unless Authuser.find_by_login(params[:authuser][:login]) == nil
      @errors << "Sorry, but that login name is already taken!"
    end

    unless params[:tos].present?
      @errors << "Sorry, but you must agree to our Terms of Service"
    end

    @authuser.email = params[:authuser][:email]
    @authuser.time_zone = params[:authuser][:time_zone]
    @authuser.login = params[:authuser][:login]
    @authuser.gender = params[:authuser][:gender]
    @authuser.prvt = false
    
    logger.info "here are the errors"
    logger.info @errors
    respond_to do |format|
      if @errors == [] && @authuser.save
        session[:authuser] = @authuser.id
        format.html { redirect_to :root, notice: 'Authuser was successfully created.' }
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
    
    #this is a bit messy...sorry he who comes after / future me!
    #to do: unify this with the edit call, which it is currently kinda paired with..messy messy
    
    @authuser = current_authuser
    @errors = []
    if @authuser.id != params[:id].to_i
      @errors << "You can't update another user's account"
    end
    if !Authuser.authenticate(@authuser.login, params[:authuser][:old_password])
      @errors << "Your the password that your provided is incorrect.  Please try again.  If you've lost your password, we can generate a new one for you"
    end
    
    if params[:authuser][:password] != params[:authuser][:password_confirmation]
      @errors << "Your new password did not match the confirmation provided.  Please try again"
    end
    if params[:authuser][:password] == ""
      params[:authuser][:password] = params[:authuser][:old_password]
    end
    unless Authuser.find_by_email(params[:authuser][:email]) != nil || Authuser.find_by_email(params[:authuser][:email]) == Authuser.find(params[:id].to_i)
      @errors << "Sorry, but that email address has already been used"
    end
    unless Authuser.find_by_login(params[:authuser][:login]) != nil || Authuser.find_by_login(params[:authuser][:email]) == Authuser.find(params[:id].to_i)
      @errors << "Sorry, but that login has already been taken.  Please choose another."
    end

    if @errors == []
      unless @authuser.update_attributes(prvt: params[:authuser][:prvt], email: params[:authuser][:email], login: params[:authuser][:login], time_zone: params[:authuser][:time_zone], crypted_password: Authuser.encrypt(params[:authuser][:password], @authuser.salt))
        @errors << "Problem updating your account.  Please try again"
      end
    end
      
        
    if @errors == []
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
        format.xml{ render :xml => @errors.to_xml, :status => :unprocessable_entity }
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


authuser = Authuser.find(params[:id])
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


