xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.landmarks{
  @landmarks.each do |lm|
    xml.landmark{
    	xml.xcoord(lm.xcoord)
    	xml.ycoord(lm.ycoord)
    }
  end
}