require 'rails_helper'

RSpec.describe "UserService", type: :business do

  let(:email) { "email@email.com" }
  let(:token_temp) { "token_temp" }
  let(:token_main) { "token_main" }
  let!(:user) { User.create(email: email, token_main: token_main, token_temp: token_temp) }
  let!(:subject) { UserService.new}

  describe ".find_user_by_email" do
    it "return user by email" do
      expect(subject.find_user_by_email(email: email)).to eq(user)
    end
  end

  describe ".find_user_by_email_and_token" do
    it "return user by email and token temp" do
      expect(subject.find_user_by_email_and_token(email: email, value: token_temp)).to eq(user)
    end
  end

  describe ".find_user_by_token" do
    it "return user by token main" do
      expect(subject.find_user_by_token(value: token_main)).to eq(user)
    end
  end

  describe ".new_user" do
    it "create new user" do
      expect(subject.new_user(email: "email2@email.com")).to eq(true)
    end
  end

  describe ".generate_token?" do
    it "xxx" do
    end
  end

  describe ".has_token?" do
    it "xxxx" do
    end
  end

  describe ".activate_token" do
    it "xxxx" do
    end
  end

end
