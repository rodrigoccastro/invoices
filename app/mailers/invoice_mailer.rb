require "pdfkit"

class InvoiceMailer < ApplicationMailer

  default from: 'notifications@example.com'

  def send_mail_invoice
    #send invoice for list of emails
    @invoice = params[:invoice]
    @root_path = params[:root_path]
    @url  = @root_path + "/invoice/show?id=#{@invoice.id}"
    attachments["invoice-#{@invoice.id}.pdf"] = generate_pdf
    mail(to: @invoice.emails, subject: "Invoice #{@invoice.id}")
  end

  private

  def generate_pdf
    #PDFKit.new(@root_path + "/invoice/show?id=#{@invoice.id}", :page_size => 'A3').to_file("invoice-#{@invoice.id}.pdf")
    #File.read("invoice-#{@invoice.id}.pdf")
 end

end
