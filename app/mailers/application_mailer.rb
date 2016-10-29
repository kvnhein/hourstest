class ApplicationMailer < ActionMailer::Base
  default from: "hourspgh@gmail.com"
  layout 'mailer'

  def sample_email(user, hour)

    @user = user
    @hour = hour
    mail(to: @user.email, subject: Venue.where(id: @hour.venue.id).first.name)
  end

   def event_reminder_email(user, events)
    @b = Time.now.in_time_zone("Eastern Time (US & Canada)").hour
    @c = (Time.now.in_time_zone("Eastern Time (US & Canada)").min)
    t= Time.now.in_time_zone("Eastern Time (US & Canada)")

    if t.wday == 0 && @b < 2
      x = 6
    elsif @b < 2
      x = t.wday - 1
    else
      x = t.wday
    end

       if  x == 0
       @day_tag = "Sunday"
       elsif x == 1
       @day_tag = "Monday"
       elsif x == 2
       @day_tag = "Tuesday"
       elsif x == 3
       @day_tag = "Wednesday"
       elsif x == 4
       @day_tag = "Thursday"
       elsif x == 5
       @day_tag = "Friday"
       else
       @day_tag = "Saturday"
       end


      if  x == 0
       @day_specials = ["Sunday","Everyday","Weekend"]
       elsif x == 1
       @day_specials = ["Monday","Everyday","Weekdays"]
       elsif x == 2
       @day_specials = ["Tuesday","Everyday","Weekdays"]
       elsif x == 3
       @day_specials = ["Wednesday","Everyday","Weekdays"]
       elsif x == 4
       @day_specials = ["Thursday","Everyday","Weekdays"]
       elsif x == 5
       @day_specials = ["Friday","Everyday","Weekdays"]
       else
       @day_specials = ["Saturday","Everyday","Weekend"]
       end

    @user = user
    @users_likes = events
    mail(to: @user.email, subject: @user.fullname)
  end
end
