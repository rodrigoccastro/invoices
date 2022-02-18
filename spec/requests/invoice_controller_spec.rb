require 'rails_helper'

RSpec.describe InvoiceController, type: :request do

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

  let(:msg_unauthorized_access) do
    { "notice" => "Acesso não autorizado!" }
  end
  let(:msg_invoice_not_exists) do
    { "notice" => "Invoice não encontrado!" }
  end
  let(:msg_params_invalids) do
    { "notice" => "Parâmetros inválidos!" }
  end
  let(:msg_invoice_invalid_data) do
    { "notice" => "Dados inválidos!" }
  end

  describe "GET #list" do
    #get "/invoice/list", to: "invoice#index"

    context "without authenticated user" do
      it "respond unauthorized access" do
        get "/invoice/list"
        expect(response).to_not be_successful

        #test just from json
        headers = { "ACCEPT" => "application/json" }
        get "/invoice/list", :headers => headers
        expect(JSON.parse(response.body)).to eq(msg_unauthorized_access.stringify_keys)
      end
    end

    context "with authenticated" do
      before do
        #session[:current_user_id] = user.id
        user = User.create(email: "email1@email.com", token_main: "12bh")
        get "/user/login", params: { email: user.email, token: user.token_main }
      end
      it "without params" do
        get "/invoice/list"
        expect(response).to be_successful

        #test just from json
        headers = { "ACCEPT" => "application/json" }
        get "/invoice/list", :headers => headers

        #verify quantity, order and content
        lista = InvoiceService.new.list_all_invoices
        expect(lista.count).to eq(3)
        expect(lista[0].id).to eq(invoice3.id)
        expect(lista[1].id).to eq(invoice2.id)
        expect(lista[2].id).to eq(invoice1.id)
        expect(JSON.parse(response.body)).to eq({ "data": lista.as_json }.stringify_keys)
      end
      it "with param date" do
        get "/invoice/list", params: { filter_type: "date", filter_value: invoice1.date }
        expect(response).to be_successful

        #test just from json
        headers = { "ACCEPT" => "application/json" }
        get "/invoice/list", params: { filter_type: "date", filter_value: invoice1.date }, :headers => headers

        #verify quantity and content
        lista = InvoiceService.new.list_invoices_by_date(date: invoice1.date)
        expect(lista.count).to eq(1)
        expect(lista[0].id).to eq(invoice1.id)
        expect(JSON.parse(response.body)).to eq({ "data": lista.as_json }.stringify_keys)
      end
    end
  end

  describe "GET #show" do
    context "without authenticated user" do
      it "respond unauthorized access" do
        get "/invoice/show"
        expect(response).to_not be_successful

        #test just from json
        headers = { "ACCEPT" => "application/json" }
        get "/invoice/show", :headers => headers
        expect(JSON.parse(response.body)).to eq(msg_unauthorized_access.stringify_keys)
      end
    end
    context "with authenticated" do
      before do
        user = User.create(email: "email1@email.com", token_main: "12bh")

        get "/user/login", params: { email: user.email, token: user.token_main }
      end
      it "without param id" do
        get "/invoice/show"

        expect(response).to_not be_successful

        #test just from json
        headers = { "ACCEPT" => "application/json" }
        get "/invoice/show", :headers => headers
        expect(JSON.parse(response.body)).to eq(msg_params_invalids.stringify_keys)
      end
      it "with param id for user exits" do
        get "/invoice/show", params: { id: invoice1.id }

        expect(response).to be_successful
        #test just from json
        headers = { "ACCEPT" => "application/json" }
        get "/invoice/show", params: { id: invoice1.id }, :headers => headers
        expect(JSON.parse(response.body)).to eq({ "data": invoice1.as_json }.stringify_keys)
      end
    end
  end

  describe "POST #create" do
    #post "/invoice/create", to: "invoice#create"
    context "without authenticated user" do
      it "respond unauthorized access" do
        post "/invoice/create"
        expect(response).to_not be_successful

        #test just from json
        headers = { "ACCEPT" => "application/json" }
        post "/invoice/create", :headers => headers
        expect(JSON.parse(response.body)).to eq(msg_unauthorized_access.stringify_keys)
      end
    end
    context "with authenticated" do
      before do
        user = User.create(email: "email1@email.com", token_main: "12bh")

        get "/user/login", params: { email: user.email, token: user.token_main }
      end
      it "without params" do
        post "/invoice/create"
        expect(response).to_not be_successful

        #test just from json
        headers = { "ACCEPT" => "application/json" }
        post "/invoice/create", :headers => headers
        expect(JSON.parse(response.body)).to eq(msg_params_invalids.stringify_keys)
      end
      it "with wrong params" do
        post "/invoice/create", params: { number: "123", date: "aaa", company: "cp", payer: "p", value: "qq", emails: "xx" }

        expect(response).to_not be_successful
      end

      it "with correct parameters" do
        post "/invoice/create", params: { number: "123", date: "2022-05-10", company: "cp", payer: "p", value: 15, emails: "xx" }

        expect(response).to be_successful
      end
    end
  end

  describe "POST #update" do
    #post "/invoice/update", to: "invoice#update"
    context "without authenticated user" do
      it "respond unauthorized access" do
        post "/invoice/update"

        expect(response).to_not be_successful
      end
    end
    context "with authenticated" do
      before do
        user = User.create(email: "email1@email.com", token_main: "12bh")

        get "/user/login", params: { email: user.email, token: user.token_main }
      end
      it "without params" do
        post "/invoice/update"

        expect(response).to_not be_successful
      end
      it "with wrong params" do
        post "/invoice/update", params: { id: invoice1.id, number: "123", date: "aaa", company: "cp", payer: "p", value: "qq", emails: "xx" }

        expect(response).to_not be_successful
      end

      it "with correct parameters" do
        post "/invoice/update", params: { id: invoice1.id, number: "123", date: "2022-05-10", company: "cp", payer: "p", value: 15, emails: "xx" }

        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    context "without authenticated user" do
      it "respond unauthorized access" do
        delete "/invoice/delete"

        expect(response).to_not be_successful
      end
    end
    context "with authenticated" do
      before do
        user = User.create(email: "email1@email.com", token_main: "12bh")

        get "/user/login", params: { email: user.email, token: user.token_main }
      end
      it "without params" do
        delete "/invoice/delete"

        expect(response).to_not be_successful
      end
      it "with wrong params" do
        delete "/invoice/delete", params: { id: 0 }

        expect(response).to_not be_successful
      end

      it "with correct parameters" do
        delete "/invoice/delete", params: { id: invoice1.id }

        expect(response).to be_successful
      end
    end
  end

end
