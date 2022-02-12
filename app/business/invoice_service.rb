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

  def new_invoice(params:)
    Invoice.new(params)
  end

end
