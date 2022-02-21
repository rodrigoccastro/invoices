class UserMailer < ApplicationMailer

  default from: 'notifications@example.com'

  def send_mail_token
    # send email to user for activate and login in your account
    @user = params[:user]
    @url  = root_path + "/user/activate?email=#{user.email}&token=#{user.token_temp}"
    mail(to: user.email, subject: "Activate your account and create invoices!")
  end

end
