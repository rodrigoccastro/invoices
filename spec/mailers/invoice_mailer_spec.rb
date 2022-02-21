require "rails_helper"

RSpec.describe InvoiceMailer, type: :mailer do

  let!(:user) { User.create(email: "email@email.com", token_main: "12bh") }
  let!(:invoice_params) do
    {user_id: user.id , number: "123", date: "2021-06-01", company: "companhia", payer: "fulano", value: 12.8, emails: "email1@email.com;email2@email.com"}
  end
  let!(:invoice) { Invoice.create(invoice_params) }

  describe ".send_mail_invoice(invoice:)" do
    it "send email with invoice" do
      user = User.create(email: "email@email.com", token_temp: "token")
      expect {
        InvoiceMailer.with(root_path: "http://localhost:3000", invoice: invoice).send_mail_invoice.deliver_now
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

end
