xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.response{
	xml.status(@returnstatus)
	xml.msg("please hit 'SAVE' again.")
}
