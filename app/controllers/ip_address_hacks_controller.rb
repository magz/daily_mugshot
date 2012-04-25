class IpAddressHacksController < ApplicationController
  # GET /ip_address_hacks
  # GET /ip_address_hacks.json
  def index
    @ip_address_hacks = IpAddressHack.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ip_address_hacks }
    end
  end

  # GET /ip_address_hacks/1
  # GET /ip_address_hacks/1.json
  def show
    @ip_address_hack = IpAddressHack.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ip_address_hack }
    end
  end

  # GET /ip_address_hacks/new
  # GET /ip_address_hacks/new.json
  def new
    @ip_address_hack = IpAddressHack.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ip_address_hack }
    end
  end

  # GET /ip_address_hacks/1/edit
  def edit
    @ip_address_hack = IpAddressHack.find(params[:id])
  end

  # POST /ip_address_hacks
  # POST /ip_address_hacks.json
  def create
    @ip_address_hack = IpAddressHack.new(params[:ip_address_hack])

    respond_to do |format|
      if @ip_address_hack.save
        format.html { redirect_to @ip_address_hack, notice: 'Ip address hack was successfully created.' }
        format.json { render json: @ip_address_hack, status: :created, location: @ip_address_hack }
      else
        format.html { render action: "new" }
        format.json { render json: @ip_address_hack.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ip_address_hacks/1
  # PUT /ip_address_hacks/1.json
  def update
    @ip_address_hack = IpAddressHack.find(params[:id])

    respond_to do |format|
      if @ip_address_hack.update_attributes(params[:ip_address_hack])
        format.html { redirect_to @ip_address_hack, notice: 'Ip address hack was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @ip_address_hack.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ip_address_hacks/1
  # DELETE /ip_address_hacks/1.json
  def destroy
    @ip_address_hack = IpAddressHack.find(params[:id])
    @ip_address_hack.destroy

    respond_to do |format|
      format.html { redirect_to ip_address_hacks_url }
      format.json { head :ok }
    end
  end
end
ad :ok }
    end
  end
end
