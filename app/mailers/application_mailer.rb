class ApplicationMailer < ActionMailer::Base
  default from: "hourspgh@gmail.com"
  layout 'mailer'

  def sample_email(user, hour)
    @user = user
    @hour = hour
    mail(to: @user.email, subject: Venue.where(id: @hour.venue.id).first.name)
  end

   def event_reminder_email(user, events)
    @user = user
    @users_likes = events
    mail(to: @user.email, subject: @user.fullname)
  end
end
