xml.instruct! :xml, :version=>"1.0" 
xml.rss :version => "2.0" do
	xml.channel do
		xml.title "#{@user.login}'s Daily Mugshot Feed"
		xml.description "#{@user.login}'s Latest Mugshot"
		xml.link "authuser_url(@user)"
		xml.item do
		  if @pic
  			xml.guid @pic.try_image
  			xml.title "Most Recent Mugshot"
  			xml.description image_tag(@pic.try_image(@format))
  			xml.pubDate @user.mugshots.last.created_at.to_s
  			xml.link @pic.try_image
    	end
		end
	end
end
