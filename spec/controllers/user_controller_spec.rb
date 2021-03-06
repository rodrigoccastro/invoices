require 'rails_helper'

RSpec.describe UserController, type: :request do

  let(:msg_param_invalid_email) do
    { "notice" => "E-mail not present" }
  end
  let(:msg_params_invalids) do
    { "notice" => "Params invalids!" }
  end
  let(:msg_token_sucess) do
    { "notice" => "Your token was regenerated. You need access your email for activate your token and login." }
  end
  let(:msg_token_existent) do
    { "notice" => "This email has token. Do you want regenerate token?" }
  end
  let(:msg_token_invalid) do
    { "notice" => "This token is invalid!" }
  end
  let(:msg_activate) do
    { "notice" => "This token was activated!" }
  end
  let(:msg_login) do
    { "notice" => "Login successfully!" }
  end
  let(:msg_deslogado) do
    { "notice" => "The user has been logged out!" }
  end

  describe "GET #token" do
    context "try generate token" do
      it "user without email param" do
        get "/user/token"
        expect(response).to_not be_successful

        #test just from json
        headers = { "ACCEPT" => "application/json" }
        get "/user/token", :headers => headers
        expect(JSON.parse(response.body)).to eq(msg_param_invalid_email.stringify_keys)
      end
      it "user without email existent" do
        params = { email: "emai12@email.com" }
        get "/user/token", params: params
        expect(response).to be_successful
      end
      it "user without token" do
        params = { email: "email1@email.com" }
        User.create(email: "email1@email.com")
        get "/user/token", params: params
        expect(response).to be_successful
      end
      it "user has token and not try regenerate" do
        User.create(email: "email1@email.com", token_main: "12bh")
        get "/user/token", params: { email: "email1@email.com" }
        expect(response).to_not be_successful
      end
      it "user has token and try regenerate" do
        User.create(email: "email1@email.com", token_main: "12bh")
        get "/user/token", params: { email: "email1@email.com", update: true }
        expect(response).to be_successful
      end
    end
  end

  describe "GET #activate" do
    context "try activate user" do
      it "without params" do
        get "/user/activate"
        expect(response).to_not be_successful
      end
      it "without token existent" do
        get "/user/activate", params: { email: "email1@email.com", token: "123" }
        expect(response).to_not be_successful
      end
      it "activate user" do
        user = User.create(email: "email1@email.com", token_temp: "12bh")
        get "/user/activate", params: { email: user.email, token: user.token_temp }
        expect(response).to be_successful
      end
    end
  end

  describe "GET #login" do
    context "try activate user" do
      it "without params" do
        get "/user/login"
        expect(response).to_not be_successful
      end
      it "without user existent" do
        get "/user/login", params: { token: "123abc" }
        expect(response).to_not be_successful
      end
      it "activate user" do
        user = User.create(email: "email1@email.com", token_main: "12bh")
        get "/user/login", params: { email: user.email, token: user.token_main }
        expect(response).to be_successful
      end
    end
  end

  describe "GET #logout" do
    context "when logged" do
      it "delete session" do
        get "/user/logout"
        expect(response).to be_successful
      end
    end
  end

end
