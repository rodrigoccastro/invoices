class InvoiceController < ApplicationController

  before_action do
    if !session || !session[:current_user_id]
      msg = "Acesso não autorizado!"
      return_response(url_redirect: root_path, msg: msg, status: :unprocessable_entity)
    end
  end

  def index
    # lista todos com paginacao?
    # pode ter filtro por data e numero invoice
    filter_type = params[:filter_type]
    filter_value = params[:filter_value]

    invoice_service = InvoiceService.new

    if !filter_type || !filter_value
      @invoices = invoice_service.list_all_invoices
      #retorno de listagem]
      return_response_render(html: :index, json: { data: @invoices }, status: :ok)
    else
      if filter_type == "date"
        @invoices = invoice_service.list_invoices_by_date(date: filter_value)
        #retorno de listagem
        return_response_render(html: :index, json: { data: @invoices }, status: :ok)
      end
      if filter_type == "id"
        msg =  "Pesquisa por id!"
        return_response(url_redirect: "/invoice/show/#{filter_value}", msg: msg, status: :ok)
      end
    end
  end

  def show
    id = params[:id]
    if !id.present?
      msg =  "Parâmetros inválidos!"
      return_response(url_redirect: "/invoice/list/", msg: msg, status: :unprocessable_entity)
      return
    end

    invoice_service = InvoiceService.new

    @invoice = invoice_service.find_by_id(id: id)
    if !@invoice.present?
      msg =  "Invoice não encontrado!"
      return_response(url_redirect: "/invoice/list/", msg: msg, status: :unprocessable_entity)
    else
      #retorno do item
      return_response_render(html: :show, json: { data: @invoice }, status: :ok)
    end
  end

  def create
    if !invoice_params_create[:number].present? || !invoice_params_create[:date].present? ||
      !invoice_params_create[:company].present? || !invoice_params_create[:payer].present? ||
      !invoice_params_create[:value].present? || !invoice_params_create[:emails].present?
      msg =  "Parâmetros inválidos!"
      return_response(url_redirect: "/invoice/list/", msg: msg, status: :unprocessable_entity)
      return
    end

    invoice_service = InvoiceService.new

    @invoice = invoice_service.new_invoice(params: invoice_params_create)
    @invoice.user_id = session[:current_user_id]

    if @invoice.save
      msg = "Invoice was successfully created."
      return_response(url_redirect: "/invoice/list/", msg: msg, status: :ok)
    else
      msg = "Dados inválidos!"
      return_response(url_redirect: "/invoice/list/", msg: msg, status: :unprocessable_entity)
    end
  end

  def update
    if !invoice_params_update[:id].present? ||
      !invoice_params_update[:number].present? || !invoice_params_update[:date].present? ||
      !invoice_params_update[:company].present? || !invoice_params_update[:payer].present? ||
      !invoice_params_update[:value].present? || !invoice_params_update[:emails].present?
      msg =  "Parâmetros inválidos!"
      return_response(url_redirect: "/invoice/list/", msg: msg, status: :unprocessable_entity)
      return
    end

    @invoice = Invoice.find_by(id: invoice_params_update[:id])
    if !@invoice.present?
      respond_to do |format|
        msg =  "Parâmetros inválidos!"
        format.html { redirect_to("/invoice/list/", status: :unprocessable_entity) }
        format.json { render json: { notice: msg }, status: :unprocessable_entity }
      end
      return
    else

      if @invoice.update(invoice_params_update)
        respond_to do |format|
          msg =  "Invoice was successfully updated."
          format.html { redirect_to("/invoice/list/", status: :ok) }
          format.json { render json: { notice: msg }, status: :ok }
        end
      else
        msg = "Dados inválidos!"
        respond_to do |format|
          format.html { redirect_to("/invoice/list/", status: :unprocessable_entity) }
          format.json { render json: { notice: msg }, status: :unprocessable_entity }
        end
        return
      end

    end
  end

  def delete
    if !params[:id].present?
      respond_to do |format|
        msg =  "Parâmetros inválidos!"
        format.html { redirect_to("/invoice/list/", notice: msg, status: :unprocessable_entity) }
        format.json { render json: { notice: msg }, status: :unprocessable_entity }
      end
      return
    end
    @invoice = Invoice.find_by(id: invoice_params_update[:id])
    if !@invoice.present?
      respond_to do |format|
        msg =  "Parâmetros inválidos!"
        format.html { redirect_to("/invoice/list/", notice: msg, status: :unprocessable_entity) }
        format.json { render json: { notice: msg }, status: :unprocessable_entity }
      end
      return
    else
      if @invoice.destroy
        respond_to do |format|
          msg = "Invoice was successfully destroyed."
          format.html { redirect_to("/invoice/list/", notice: msg, status: :ok) }
          format.json { render json: { notice: msg }, status: :ok }
        end
        return
      else
        respond_to do |format|
          msg = "Invoice was not destroyed."
          format.html { redirect_to("/invoice/list/", notice: msg, status: :unprocessable_entity) }
          format.json { render json: { notice: msg }, status: :unprocessable_entity }
        end
        return
      end
    end
  end

  private

  def invoice_params_create
    params.permit(:number, :date, :company, :payer, :value, :emails)
  end
  def invoice_params_update
    params.permit(:id, :number, :date, :company, :payer, :value, :emails)
  end

  def return_response(url_redirect:, msg:, status:)
    respond_to do |format|
      format.html { redirect_to(url_redirect, notice: msg, status: status) }
      format.json { render json: { notice: msg }, status: status }
    end
  end
  def return_response_render(html:, json:, status:)
    respond_to do |format|
      format.html { render :index, status: :ok }
      format.json { render json: { data: @invoices }, status: :ok }
    end
  end
end
