require 'rails_helper'

RSpec.describe User, type: :model do

  subject {
    described_class.new(email: "email@email.com", token_main: "12rh56bc", token_temp: "78rh90bc")
  }

  it "with valid attributes" do
    expect(subject).to be_valid
  end

  it "without email" do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it "without valid email" do
    subject.email = "email@email/com"
    expect(subject).to_not be_valid
  end

end
