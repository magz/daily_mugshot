class IphoneController < ApplicationController
  skip_before_filter :require_login
  skip_before_filter :login_from_cookie
  def loginxml
    #this should mostly all work except that image resize bit
    #o and set up the route (with this post restriction)
    #return unless request.post?
    
    #checking to make sure that such a user exists...not perfect.  Makes sure a response is provided though, rather than just erroring out
    if Authuser.find_by_login(params[:login])
      current_authuser = Authuser.authenticate(params[:login], params[:password])
    else
      current_authuser = false
    end
    if current_authuser
      session[:authuser_id] = current_authuser.id
      #gotta get this remember token stuff filed away
      #self.current_authuser.remember_me
      #what's this all about?
      #cookies[:_daily_mugshot_auth_token] = { :value => self.current_authuser.remember_token , :expires => 1.year.from_now } 
      @id = current_authuser.id
      @count = current_authuser.mugshots.count
      if @count > 0 then
        last_mugshot = current_authuser.mugshots.last
        @last = last_mugshot.created_at.strftime("%Y-%m-%d %H:%M:%S")
        #this is batshit insane...i'm going to send the 200x200 for now and figure out how to downsize the 400x400 to 320x320 later 
        #@my_url = pull_down_iphone(pic_full)
        @my_url = last_mugshot.try_image "inner"
      else
        @last = "-1"
        @my_url = "-1"
      end
      @failure = 0
    else
      @failure = 1
    end
    request.format = "xml"
    respond_to do |format|
      if @failure == 0 then
        format.xml { render :action => 'loginxml', :layout => false }
      else
        format.xml { render :action => 'loginfailure', :layout => false }
      end
    end
  end
  
  def signup

    @authuser = Authuser.new(params[:authuser])
    #check this out...time_zone stuff isn't finalized as of yet in the new code
    @authuser.time_zone = "US/Pacific"
    
    #probably move this to routes
    unless request.post?
      render :layout => false
      return
    end
    #not sure what the regex here is about, but let's trust it for now
    @authuser.login = @authuser.login.gsub(/\W/,'')
    #um ok?  shouldn't this be a ||= expression? w/e
    @authuser.time_zone = params[:authuser][:time_zone]
    #shouldn't there be some kinda thing to make sur the params are valid?  biza
    @authuser.save!
    
    #why is this here?
    self.current_authuser = @authuser


    #don't have this yet...low priority frankly
    #create an associated emailreminder
    # emailreminder = Emailreminder.new
    # emailreminder.authuser_id = @authuser.id
    # emailreminder.save!

    #i don't think these renders are going to work properly as is
    redirect_to :action => 'ready'
    flash[:notice] = "Thanks for signing up!"
  
  #why are we doing this as a rescue?  gr!
  rescue ActiveRecord::RecordInvalid
      #this definitely doesn't work as is
      render :action => 'signup', :layout => false
  end
  


end