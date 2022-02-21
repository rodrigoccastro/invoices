require 'rails_helper'

RSpec.describe "InvoiceService", type: :business do

  let!(:subject) { InvoiceService.new }
  let!(:user) { User.create(email: "email@email.com", token_main: "12bh") }
  let!(:invoice_params1) do
    {user_id: user.id , number: "123", date: "2021-06-01", company: "companhia", payer: "fulano", value: 12.8, emails: "email1@email.com;email2@email.com"}
  end
  let!(:invoice_params2) do
    {user_id: user.id , number: "123456", date: "2021-07-01", company: "companhia", payer: "fulano", value: 12.8, emails: "email1@email.com;email2@email.com"}
  end
  let!(:invoice_params3) do
    {user_id: user.id , number: "123789", date: "2021-08-01", company: "companhia", payer: "fulano", value: 12.8, emails: "email1@email.com;email2@email.com"}
  end
  let!(:invoice1) { Invoice.create(invoice_params1) }
  let!(:invoice2) { Invoice.create(invoice_params2) }
  let!(:invoice3) { Invoice.create(invoice_params3) }
  let(:root_path) { "http://localhost:3000" }

  describe ".list_all_invoices" do
    it "return all invoices" do
      list = subject.list_all_invoices(user_id: user.id)
      expect(list.count).to eq(3)
      expect(list[0].id).to eq(invoice3.id)
      expect(list[1].id).to eq(invoice2.id)
      expect(list[2].id).to eq(invoice1.id)
    end
  end

  describe ".list_invoices_by_date(date:)" do
    it "return list of invoices by date" do
      list = subject.list_invoices_by_date(user_id: user.id, date: invoice1.date)
      expect(list.count).to eq(1)
      expect(list[0].id).to eq(invoice1.id)
    end
  end

  describe ".find_by_id(id:)" do
    it "return invoice by id" do
      obj = subject.find_by_id(user_id: user.id, id: invoice1.id)
      expect(obj.id).to eq(invoice1.id)
    end
  end

  describe ".new_invoice(user_id:, params:)" do
    it "new invoice" do
      params = { number: "number upd", date: "2022-11-12",
        company: "company upd", payer: "payer upd",
        value: 345, emails: "email@email.com" }

      expect(subject.new_invoice(root_path: root_path, user_id: user.id, params: params)).to eq(true)
    end
  end

  describe ".update(invoice:, params:)" do
    it "update invoice" do
      params = { number: "number upd", date: "2022-11-12",
                company: "company upd", payer: "payer upd",
                value: 345, emails: "email@email.com" }

      expect(subject.update(invoice: invoice1, params: params)).to eq(true)
      obj = subject.find_by_id(user_id: user.id, id: invoice1.id)
      expect(obj.number).to eq (params[:number])
      expect(obj.date).to eq (params[:date])
      expect(obj.company).to eq (params[:company])
      expect(obj.payer).to eq (params[:payer])
      expect(obj.value).to eq (params[:value])
      expect(obj.emails).to eq (params[:emails])
    end
  end

  describe ".delete(invoice:)" do
    it "delete invoice" do
      expect(subject.delete(invoice: invoice1)).to eq(true)
    end
  end

end
