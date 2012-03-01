class RssController < ApplicationController
  skip_before_filter :require_login
  def feed
    if params[:login] == nil || params[:size] == nil
      #no user given
      redirect_to :action => "user_not_found"
      return
    else
      @user = Authuser.find_by_login(params[:login])
      if @user == nil || @user.prvt == 1
        #could not find user
        redirect_to :action => "user_not_found"
        return
      end
      @pic = @user.mugshots.last
      if params[:size] == 'thumb'
        @format="thumb"
      elsif params[:size] == 'main'
        @format="inner"
      end
    request.format = "xml"
      respond_to do |format|
        format.xml
      end
    end
      
      
      # if params[:size] == 'thumb'
      #     @format
      #     @pic = @user.mugshots.last.try_image "thumb"
      # elsif params[:size] == 'main'
      #     @pic = @user.mugshots.last.try_image "inner"
      # else
      #   redirect_to :action => "user_not_found"
      #   return                
      # end
    #   request.format = "xml"
    #   respond_to do |format|
    #     format.xml
    #   end
    # end
  end

  def user_not_found

  end

  
end #end of class
