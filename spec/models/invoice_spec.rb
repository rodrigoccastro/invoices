require 'rails_helper'

RSpec.describe Invoice, type: :model do

  let(:user) { User.create(email: "email@email.com", token_main: "token_main") }

  subject {
    described_class.new(user: user, number: "1234",
                        date: "2022-06-01", company: "company",
                        payer: "payer", value: 12.8,
                        emails: "email1@email.com;email2@email.com;email3@email.com")
  }

  it "with valid attributes" do
    expect(subject).to be_valid
  end

  it "without number" do
    subject.number = nil
    expect(subject).to_not be_valid
  end

  it "without date" do
    subject.date = nil
    expect(subject).to_not be_valid
  end

  it "without company" do
    subject.company = nil
    expect(subject).to_not be_valid
  end

  it "without payer" do
    subject.payer = nil
    expect(subject).to_not be_valid
  end

  it "without value" do
    subject.value = nil
    expect(subject).to_not be_valid
  end

  it "without emails" do
    subject.emails = nil
    expect(subject).to_not be_valid
  end

end
