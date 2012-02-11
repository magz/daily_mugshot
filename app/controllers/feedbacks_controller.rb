class FeedbacksController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create]
  before_filter :require_admin, :except => [:new, :create]
  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @feedbacks = Feedback.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feedbacks }
    end
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/new
  # GET /feedbacks/new.json
  def new
    @feedback = Feedback.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feedback }
    end
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(params[:feedback])
    if logged_in?
      @feedback.authuser_id = current_authuser
    end

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to :root, notice: 'Thank you for your feedback!' }
        format.json { render json: @feedback, status: :created, location: @feedback }
      else
        format.html { render action: "new" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1
  # PUT /feedbacks/1.json

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to feedbacks_url }
      format.json { head :ok }
    end
  end
end
