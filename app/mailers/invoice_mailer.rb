class InvoiceMailer < ApplicationMailer

  def send_mail_token(email:, token:)
    # Sendo que nesse email deverá ter um link para ativar o token
    # e logar o usuário em seguida.
    #....

  end
  def send_mail_invoice(invoice:)
    #As invoices deverão ser enviadas por email com:
    #Corpo de e-mail
    #Link para visualização
    #Anexo
    #Versão da invoice como PDF

    #emails = @invoice.emails.split(',')
    #mail(to: emails, subject: "Invoice #{@invoice.id}")
  end
end
