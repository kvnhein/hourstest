class ApplicationMailer < ActionMailer::Base
  default from: "hourspgh@gmail.com"
  layout 'mailer'

  def sample_email(user, hour)
    @user = user
    @hour = hour
    mail(to: @user.email, subject: 'Hours Reminder')
  end
end
