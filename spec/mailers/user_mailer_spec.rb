require "rails_helper"

RSpec.describe InvoiceMailer, type: :mailer do

  describe ".send_mail_token(email:, token:)" do
    it "send email for activate token" do
      user = User.create(email: "email@email.com", token_temp: "token")
      expect {
        UserMailer.with(root_path: "http://localhost:3000", user: user).send_mail_token.deliver_now
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

end
