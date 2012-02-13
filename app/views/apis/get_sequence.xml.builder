xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.sequences{
  if @pics
    @pics.each do |pic|
      xml.pic{
      	xml.image_url(pic.try_image("inner"))
  	xml.caption(pic.caption)
      	xml.created(pic.created_at.to_date)
      }
    end
  end
}
