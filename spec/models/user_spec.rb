require 'rails_helper'

RSpec.describe "User", type: :model do

  let(:email_valid) { "email@email.com" }
  let(:email_invalid) { "email@email/com" }
  let(:user) { User.new(email: email_invalid) }
  let(:token_main) { "12rh56bc" }
  let(:token_temp) { "78rh90bc" }

  context "try save with invalid email" do
    it "validation values" do
      expect(user.save).to eq(false)
    end
  end

  context "try save with valid values" do
    it "validation values" do
      expect(user.update(email: email_valid)).to eq(true)
      expect(user.update(token_main: nil, token_temp: nil)).to eq(true)
      expect(user.update(token_main: token_main, token_temp: token_temp)).to eq(true)
    end
  end

end
