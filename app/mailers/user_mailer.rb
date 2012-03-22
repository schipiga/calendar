class UserMailer < ActionMailer::Base
  default from: "recovery_password@calendar.com"

  def recovery_pswd(user)
    mail(:to => user[:email], :subject => 'Recovery password')
  end

end
