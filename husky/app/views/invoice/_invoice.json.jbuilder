json.extract! invoice, :id, :number, :date, :company, :payer, :value, :emails, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
