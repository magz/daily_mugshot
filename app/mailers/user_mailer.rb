class UserMailer < ActionMailer::Base
  
  
  
  def misses_you(user)
    @authuser = Authuser.find(user)
    mail(:from => "noreply@fuzzproductions.com", :to => @authuser.email, :subject => "Daily Mugshot Misses You!")
  end
  
  def forgot_password(user, password)
  @authuser = Authuser.find(user)
  @password = password
  mail(:from => "noreply@fuzzproductions.com", :to => @authuser.email, :subject => "Daily Mugshot - Password Reset Request")
  
  end
  
  def signup_email(user)
    @authuser = Authuser.find(user)
    mail(:from => "noreply@fuzzproductions.com", :to => @authuser.email, :subject => "Daily Mugshot - Signup")
  end
  def send_reminders(hour)
    #find all users where their requested time and time zone mathces
    #iterate over that group and send a mail to each of them
  end
end
 to each of them
  end
end
