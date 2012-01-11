class AuthusersController < ApplicationController
  # GET /authusers
  # GET /authusers.json
  def index
    #this could maybe be slightly more efficient
    @authusers = []
    Authuser.where(:prvt => false, :active => true).each do |user|
      if user.has_mugshot?
        @authusers << user
      end
    end
    @authusers.sort!{|a,b| a.last_mugshot_date <=> b.last_mugshot_date}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authusers }
    end
  end
  def search
    @authusers = []
    #now how to do this search thign?
    Authuser.where(:prvt => false, :active => true).each do |user|
      if user.has_mugshot?
        @authusers << user
      end
    end
    @authusers.sort!{|a,b| a.last_mugshot_date <=> b.last_mugshot_date}
    
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @authuser }
    end
  end
  
  def show_mine
    @authuser = current_authuser
    @comments = Comment.where(:authuser_id => @authuser).order("created_at DESC")
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @authuser }
    end
  end
  # GET /authusers/new
  # GET /authusers/new.json
  def new
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

    respond_to do |format|
      if @authuser.save
        format.html { redirect_to @authuser, notice: 'Authuser was successfully created.' }
        format.json { render json: @authuser, status: :created, location: @authuser }
      else
        format.html { render action: "new" }
        format.json { render json: @authuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /authusers/1
  # PUT /authusers/1.json
  def update
    @authuser = Authuser.find(params[:id])

    respond_to do |format|
      if @authuser.update_attributes(params[:authuser])
        format.html { redirect_to @authuser, notice: 'Authuser was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @authuser.errors, status: :unprocessable_entity }
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
end
