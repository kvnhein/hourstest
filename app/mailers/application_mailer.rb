class ApplicationMailer < ActionMailer::Base
  default from: "hourspgh@gmail.com"
  layout 'mailer'
  
  def sample_email(user)
    @user = user
    mail(to: @user.email, subject: 'Sample Email')
  end
end
