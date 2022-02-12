class InvoiceService

  def list_all_invoices()
    Invoice.order('created_at DESC')
  end

  def list_invoices_by_date(date:)
    Invoice.where(date: date).order('created_at DESC')
  end

  def find_by_id(id:)
    Invoice.find_by(id:id)
  end

  def update (invoice:, params:)
    invoice.update(params)
  end

  def new_invoice(user_id:, params:)
    user = Invoice.new(params)
    user.user_id = user_id
    user
  end

end
