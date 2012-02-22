class MugshotsController < ApplicationController
  # GET /mugshots
  # GET /mugshots.json
  def index
    @mugshots = Mugshot.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mugshots }
    end
  end

  # GET /mugshots/1
  # GET /mugshots/1.json
  def show
    @mugshot = Mugshot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mugshot }
    end
  end

  # GET /mugshots/new
  # GET /mugshots/new.json
  def new
    #check if it's their first pic
    @mugshot = Mugshot.new
    @authuser = current_authuser
    
    #check if they've taken a pic today
    if Mugshot.where(:authuser_id => @authuser.id, :created_at => Date.today).exists?
      flash[:notice] << "You've already taken a picture today!  You'll have to have until tomorrow to take another"
      redirect_to :root and return
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mugshot }
    end
  end
  
  def first_pic
    @authuser = current_authuser
  end
  # GET /mugshots/1/edit
  def edit
    @mugshot = Mugshot.find(params[:id])
  end

  # POST /mugshots
  # POST /mugshots.json
  def create
    @mugshot = Mugshot.new(params[:mugshot])

    respond_to do |format|
      if @mugshot.save
        @mugshot.authuser.update_mugshot_count
        format.html { redirect_to @mugshot, notice: 'Mugshot was successfully created.' }
        format.json { render json: @mugshot, status: :created, location: @mugshot }
      else
        format.html { render action: "new" }
        format.json { render json: @mugshot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mugshots/1
  # PUT /mugshots/1.json
  def update
    @mugshot = Mugshot.find(params[:id])

    respond_to do |format|
      if @mugshot.update_attributes(params[:mugshot])
        format.html { redirect_to @mugshot, notice: 'Mugshot was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @mugshot.errors, status: :unprocessable_entity }
      end
    end
  end
  def ajax_active_update
    @mugshot = Mugshot.find(params[:id])
    
    @mugshot.active = @mugshot.active ? false : true
    
    @mugshot.save
    @mugshot.authuser.update_mugshot_count

    respond_to do |format|
      format.json { head :ok }
    end
  end
  def ajax_image_fetch
    @mugshot_url = Authuser.find(params[:id]).mugshots.last.try_image
    respond_to do |format|
      format.json { render json: {image: @mugshot_url, id: params[:index].to_s} }
    end
  end
 
  # def get_multi_box_update
  #   #this is my new ajax call for the front page..magz
  #   @mugshot = Mugshot.where("image_file_name != 'nil'").last
  #   @authuser = @mugshot.authuser
  #   gender = @authuser.gender == "m" ? "his" : "her"
  #   @hash = {image: @mugshot.try_image("inner"), userid: @authuser.id, message: (@authuser.login + " just took " + gender + " " + @authuser.mugshots.count.ordinalize + " mugshot!")}
  #   respond_to do |format|
  #     format.html { render :layout => false }
  #     format.json { render json: @hash }
  #     format.js
  #   end
  # end

  # DELETE /mugshots/1
  # DELETE /mugshots/1.json
  def destroy
    @mugshot = Mugshot.find(params[:id])
    @mugshot.destroy
    @mugshot.authuser.update_mugshot_count


    respond_to do |format|
      format.html { redirect_to mugshots_url }
      format.json { head :ok }
    end
  end
end
