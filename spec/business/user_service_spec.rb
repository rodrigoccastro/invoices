require 'rails_helper'

RSpec.describe "UserService", type: :business do

  let(:email) { "email@email.com" }
  let(:token_temp) { "token_temp" }
  let(:token_main) { "token_main" }
  let!(:user) { User.create(email: email, token_main: token_main, token_temp: token_temp) }

  describe ".find_user_by_email" do
    it "return user by email" do
      expect(UserService.new.find_user_by_email(email: email)).to eq(user)
    end
  end

  describe ".find_user_by_email_and_token" do
    it "return user by email and token" do
      expect(UserService.new.find_user_by_email_and_token(email: email, value: token_temp)).to eq(user)
    end
  end

  describe ".find_user_by_token" do
    it "xxxx" do
      #expect(product_follow_repository).to receive(:get_recently_products).with(user_id: user_id).and_return(active_relation)
      #expect(subject.call).to eq(active_relation)
    end
  end

  describe ".new_user" do
    it "xxxx" do
      #expect(product_follow_repository).to receive(:get_recently_products).with(user_id: user_id).and_return(active_relation)
      #expect(subject.call).to eq(active_relation)
    end
  end

  describe ".has_token?" do
    it "xxxx" do
      #expect(product_follow_repository).to receive(:get_recently_products).with(user_id: user_id).and_return(active_relation)
      #expect(subject.call).to eq(active_relation)
    end
  end

  describe ".activate_token" do
    it "xxxx" do
      #expect(product_follow_repository).to receive(:get_recently_products).with(user_id: user_id).and_return(active_relation)
      #expect(subject.call).to eq(active_relation)
    end
  end

end
