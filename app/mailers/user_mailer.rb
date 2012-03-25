class UserMailer < ActionMailer::Base
  default :from => 'recovery_password@calendar.com'

  def recovery_pswd(email, link)
    mail(:to => email, :subject => "You can recovery your password here: #{link}")
  end

end
