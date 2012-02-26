xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.alarm{
    xml.protocol_version(@protocol_version)
    xml.newest_mac_client(@mac_version)
    xml.newest_win_client(@win_version)
    xml.user(@user.login)
    xml.last_mugshot(@last.created_at.strftime("%Y-%m-%d %H:%M:%S"))
    xml.next_mugshot(@pic_count + 1)
    xml.alert_text{
    	xml.last("Your last mugshot was taken #{@last.created_at.strftime("%Y-%m-%d %H:%M:%S")} ")	
    	xml.next("Its time to take your #{(@pic_count + 1).ordinalize} mugshot!")
    }
}
