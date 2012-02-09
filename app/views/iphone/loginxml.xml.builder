xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.user{
	xml.id(@id)
	xml.count(@count)
	xml.last(@last)
	xml.url(@my_url)
}
