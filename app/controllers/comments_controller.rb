class CommentsController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create, :ajax_remove_comment]
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    if params[:id].to_i == current_authuser.id
      @comment = Comment.new
      @comment.body = params[:comment][:body]
      @comment.authuser_id = params[:id]
      @comment.owner_id = params[:owner_id]
    end
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
          format.js { render_to_string(:partial=>'authusers/comments?test=true').html_safe}
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        
        
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    if (current_authuser.id == @comment.owner_id || current_authuser.id == @comment.authuser_id)
      @comment.destroy
      flash[:notice] = "Comment successfully removed"
    else
      flash[:notice] = "You are not authorized to remove that comment"
    end
    session[:return_to] ||= request.referer
    redirect_to session[:return_to]
    
    # respond_to do |format|
    #   format.html { redirect_to :back }
    #   format.json { head :ok }
    #   
    # end
  end
  # def ajax_remove_comment
  #   unless params[:id] == nil
  #       @comment = Comment.find_by_id(params[:id])
  #       unless @comment == nil
  #         if logged_in?
  #           if (current_authuser.id == @comment.owner_id || current_authuser.id == @comment.authuser_id)
  #             @comment.destroy
  #           end
  #         end
  #       end
  #   end
  #   respond_to do |format|
  #     format.html { redirect_to :action => "show", :id => authuser_id}
  #     format.js
  #   end
  # end
  def assemble_js_response(id)
    @comments = Comment.where(owner_id: id)
    #there HAS to be a better way to do this
    str = "<ul class='comment_list' >
    <div id='inner_comment_container'>"
  	@alernating = true
  	for comment in @comments
  	  @alernating = !alernating
  	  str << "<li id='comment_#{comment.id}' class='#{@alternating}'>
  	    <div class='comment_content'>
  	      <h4 class='comment_title'>"
  	  if comment.authuser_id == -1 
  	    str << "<span class='comment_auth'>anonymous</span>"
  	  else
  	    str << "<a href='/authusers/#{comment.authuser.id}' class='comment_auth'>#{comment.authuser.login}</a>"
      end
        str << "<span class='comment_date'>#{comment.created_at.strftime('%m/%d/%y')}</span>"
  	  #delete goes here
  	    
  	    str << "</h4>"
  	    if comment.authuser_id == -1 || !comment.authuser.get_last_mugshot
  	      str << "<img alt='Dmslogo_med' class='comment_pic' src='/assets/dmslogo_med.png' />"
        else
          #to be continued
  	    end
  	  
  	  
  	  
  	  
  	end
  
  
  
  
  end
end
