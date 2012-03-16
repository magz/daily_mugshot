class FriendshipsController < ApplicationController
  # GET /friendships
  # GET /friendships.json
  
  before_filter :require_admin, :except => [:add_follow, :remove_follow]
  
  def add_follow
    @friendship = Friendship.new
    @friendship.authuser = current_authuser
    @friendship.followee = Authuser.find(params[:followee_id])
    @friendship.save
    respond_to do |format|
        format.js do 
          template_format = :html
          @new_link_html = "<a href='/frienships/remove_follow?followee_id=" + params[:followee_id] + " class='remove_friend' data-remote='true' id='friend_link'>Remove from favorites </a> <span id='friendStatus'></span>"
          render :json => { :success => true, :user_html => @new_link_html, :new_class => "remove_friend" }

        end
    end
    
  end
  
  def remove_follow
    @friendship = Friendship.find_by_authuser_id_and_followee_id(current_authuser, params[:followee_id])
    logger.info @frienship == nil
    @friendship.delete if @friendship
    respond_to do |format|
        format.js do 
          template_format = :html
          @new_link_html = "<a href='/frienships/add_follow?followee_id=" + params[:followee_id] + " class='add_friend' data-remote='true' id='friend_link'>Add to favorites </a> <span id='friendStatus'></span>"
          render :json => { :success => true, :user_html => @new_link_html, :new_class => "add_friend" }

        end
    end
    
  end
  
  
  def index
    @friendships = Friendship.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @friendships }
    end
  end

  # GET /friendships/1
  # GET /friendships/1.json
  def show
    @friendship = Friendship.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @friendship }
    end
  end

  # GET /friendships/new
  # GET /friendships/new.json
  def new
    @friendship = Friendship.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @friendship }
    end
  end

  # GET /friendships/1/edit
  def edit
    @friendship = Friendship.find(params[:id])
  end

  # POST /friendships
  # POST /friendships.json
  def create
    @friendship = Friendship.new(params[:friendship])

    respond_to do |format|
      if @friendship.save
        format.html { redirect_to @friendship, notice: 'Friendship was successfully created.' }
        format.json { render json: @friendship, status: :created, location: @friendship }
      else
        format.html { render action: "new" }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /friendships/1
  # PUT /friendships/1.json
  def update
    @friendship = Friendship.find(params[:id])

    respond_to do |format|
      if @friendship.update_attributes(params[:friendship])
        format.html { redirect_to @friendship, notice: 'Friendship was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy

    respond_to do |format|
      format.html { redirect_to friendships_url }
      format.json { head :ok }
    end
  end
end
