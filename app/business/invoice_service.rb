class InvoiceService

  def list_all_invoices(user_id:)
    Invoice.where(user_id: user_id).order('created_at DESC')
  end

  def list_invoices_by_date(user_id:, date:)
    Invoice.where(user_id: user_id).where(date: date).order('created_at DESC')
  end

  def find_by_id(user_id:, id:)
    if user_id.present?
      Invoice.where(user_id: user_id).where(id: id).take
    else
      Invoice.find(id)
    end
  end

  def new_invoice(root_path:, user_id:, params:)
    invoice = Invoice.new(params)
    invoice.user_id = user_id
    if invoice.save
      InvoiceMailer.with(root_path: root_path, invoice: invoice).send_mail_invoice.deliver_later
      return true;
    end
    return false;
  end

  def update(invoice:, params:)
    invoice.update(params)
  end

  def delete(invoice:)
    invoice.destroy.present?
  end

end
