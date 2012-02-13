xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.full{
  if @full
  	xml.path(@full.try_image "full")
  	xml.created(@full.created_at)
  	xml.xoffset(@full.xoffset)
  	xml.yoffset(@full.yoffset)
	end
}
