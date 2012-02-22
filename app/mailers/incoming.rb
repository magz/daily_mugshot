# require 'net/pop'


# class Incoming < ActionMailer::Base
#     def self.check_mail
#     Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
#     Net::POP3.start("pop.gmail.com", 995, POP_CONFIG['username'], POP_CONFIG['password']) do |pop|
#       pop.mails.each do |email|
#         begin
#           receive(email.pop)
#         rescue Exception => e
#           EMAIL_LOGGER.debug e.inspect
#           EMAIL_LOGGER.debug e.backtrace.join("\n")
#         end
        
#         email.delete
#       end
#     end
#   rescue Exception => e
#     EMAIL_LOGGER.debug e.inspect
#     EMAIL_LOGGER.debug e.backtrace.join("\n")
#   end
  
#   def receive(email)
    
#     #verify that the sender has a DMS account and mobile entry 
#     sender = email.from[0].to_s
#     #EMAIL_LOGGER.debug("\nMail received from #{sender} at #{Time.now}")
#     user = Authuser.find_by_email
#     if user == nil then
#       #EMAIL_LOGGER.debug("userdetail not found")
#       return
#     end
#     if user == nil then
#       #EMAIL_LOGGER.debug("user not found")
#       return
#     end
    
#     #make sure this user did not already take a mugshot today
#     if user.already_taken_today?  
#       #EMAIL_LOGGER.debug("pic already taken")
#       MobileNotifier.deliver_already_taken(user)
#       return
#     end

#     #Process attachment
#     #EMAIL_LOGGER.debug("has attachment? #{email.has_attachments?}")
#     if email.has_attachments?
#       #only deal with first attachment
#       attachment = email.attachments[0]
#       #save attachment in tmp directory
#       # filename = Time.now.to_f.to_s
#       # (0..9).each {|i| filename += (rand(24)+97).chr}
#       # dir = Rails.root.join('public/tmp')
#       # Dir.mkdir(Rails.root.join('public/tmp')) unless File.directory?(dir)
#       # tmp_path = File.join(RAILS_ROOT,"public","tmp",filename + ".jpg")
#       # File.open( tmp_path,File::CREAT|File::TRUNC|File::WRONLY,0666){ |f|
#       #   f.write(attachment.read)
#       # }
#       #make sure the file is really an image
#       new_mugshot = Mughsot.new
#       new_mugshot.image = attachment.read
#       new_mugshot.caption = email.subject.to_s.gsub(/[^A-Za-z0-9_\s\?\(\)\!\.\,]/,'')
#       new_mugshot.authuser_id = user.id
#       new_mugshot.save = attachment.read
#         #EMAIL_LOGGER.debug("Image successfully captured.")
#       else
#         #EMAIL_LOGGER.debug("attachment is not an image.")
#         MobileNotifier.deliver_not_an_image(user)
#         return
#       end
#     end
#   end
# end


# end







