require 'rails_helper'

RSpec.describe "UserService", type: :business do

  let(:email) { "email@email.com" }
  let(:token_temp) { "token_temp" }
  let(:token_main) { "token_main" }
  let!(:user) { User.create(email: email, token_main: token_main, token_temp: token_temp) }
  let!(:subject) { UserService.new}
  let(:root_path) { "http://localhost:3000" }

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
      expect(subject.new_user(root_path: root_path, email: "email2@email.com").present?).to eq(true)
    end
  end

  describe ".generate_token" do
    it "generate token" do
      user2 = subject.new_user(root_path: root_path, email: "email2@email.com")
      expect(subject.generate_token(user: user2)).to eq(true)
    end
  end

  describe ".activate_token" do
    it "activate token" do
      user2 = subject.new_user(root_path: root_path, email: "email2@email.com")
      subject.generate_token(user: user2)
      expect(subject.activate_token(user: user2)).to eq(true)
    end
  end

  describe ".has_token?" do
    it "has token?" do
      user2 = subject.new_user(root_path: root_path, email: "email2@email.com")
      subject.generate_token(user: user2)
      subject.activate_token(user: user2)
      expect(subject.has_token?(user: user2)).to eq(true)
    end
  end

end
