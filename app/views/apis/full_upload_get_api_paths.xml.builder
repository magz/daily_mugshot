xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.Paths{
	xml.apipath("/apis")
	xml.uploadpath("apis/upload_with_id/" + @id)
}