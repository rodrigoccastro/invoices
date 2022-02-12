require 'rails_helper'

RSpec.describe Invoice, type: :model do

  let(:user) { User.create(email: "email@email.com", token_main: "token_main") }
  let(:number) { "1234" }
  let(:date) { "2022-06-01" }
  let(:company) { "company" }
  let(:payer) { "payer" }
  let(:value) { 12.8 }
  let(:emails) { "email1@email.com;email2@email.com;email3@email.com" }
  let(:invoice) { Invoice.new(user_id: user.id, number: number, date: date, company: company, payer: payer, value: value, emails: emails) }

  context "try save without values" do
    it "validation values" do
      expect(Invoice.new.save).to eq(false)
    end
  end

  context "try save with values" do
    it "validation values" do
      expect(invoice.save).to eq(true)
    end
  end

end
