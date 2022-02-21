class InvoiceMailer < ApplicationMailer

  default from: 'notifications@example.com'

  def send_mail_invoice(invoice:)
    #send invoice for list of emails
    @url  = root_path + "/invoice/show?id=#{invoice.id}"
    #attachment generate_pdf(invoice:)
    mail(to: invoice.emails, subject: "Invoice #{invoice.id}")
  end

  private

  def generate_pdf(invoice:)
    #...
  end

end
