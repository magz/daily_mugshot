# 
# 
# 
# def authuser_data_transfer(json_data)
#   #json data should be an array
#   json_data.each do |entry|
#     begin
#       entry.delete("invites")
#       entry.delete("type")
#       a=Authuser.new()
#       a.id = entry["id"].to_i
#       entry.delete("id")
#       a.update_attributes(entry)
#       a.save
#     rescue
#       puts "EMERGENCY SOMETHIGN WENT WRONG!"
#       puts entry
#       puts "that is the one that went wrong ^^^^^^^"
#     end
#   end
# end
# def name_file_get_json(target)
#   result = JSON.parse File.read File.open target
# end
# 
# def mugshot_data_transfer(json_data)
#   json_data.each do |entry|
#     begin
#       fetched_image = open ("http://www.dailymugshot.com/secret_photo_fetch/" + entry["id"] )
#       id = entry["id"]
#       entry.update({:created_at => entry["created"]})
#       entry.delete("id")
#       entry.delete("filename")
#       entry.delete("created")
#       m = Mugshot.new(entry)
#       m.id = id
#       m.image = fetched_image
#       m.save
#     rescue
#       puts "EMERGENCY SOMETHING WENT WRONGPICFULL!!!"
#       puts entry
#       begin 
#         puts "and the id is" + id.to_s
#       rescue
#       end
#       puts "ALERT!"
#     end
# end
# end
# 
# def mugshot_data_transfer_no_image(json_data)
#   json_data.each do |entry|
#     begin
#       # fetched_image = open ("http://www.dailymugshot.com/secret_photo_fetch/" + entry["id"] )
#       id = entry["id"]
#       entry.update({:created_at => entry["created"]})
#       entry.delete("id")
#       entry.delete("filename")
#       entry.delete("created")
#       m = Mugshot.new(entry)
#       m.id = id
#       # m.image = fetched_image
#       m.save
#     rescue
#       puts "EMERGENCY SOMETHING WENT WRONGPICFULL!!!"
#       puts entry
#       begin 
#         puts "and the id is" + id.to_s
#       rescue
#       end
#       puts "ALERT!"
#     end
# end
# end
# 
# def get_images_for_blank_mugshots
#   Mugshot.where(:image_file_name => nil).each do |m|
#     begin
#       m.image = open ("http://www.dailymugshot.com/secret_photo_fetch/" + m.id.to_s )
#       m.save
#     rescue
#       puts "ERRROR!  PROBABLY IMAGE NOT FOUND!"
#     end
#   end
# end
# 
