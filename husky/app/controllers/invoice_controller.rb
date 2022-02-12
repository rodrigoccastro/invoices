class InvoiceController < ApplicationController

  before_action do
    if !session || !session[:current_user_id]
      msg = "Acesso não autorizado!"
      respond_to do |format|
        format.html { redirect_to(root_path, notice: msg, status: :unprocessable_entity) }
        format.json { render json: { notice: msg }, status: :unprocessable_entity }
      end
    end
  end

  def index
    # lista todos com paginacao?
    # pode ter filtro por data e numero invoice
    filter_type = params[:filter_type]
    filter_value = params[:filter_value]

    if !filter_type || !filter_value
      @invoices = Invoice.order('created_at DESC')
      #retorno de listagem
      respond_to do |format|
        format.html { render :index, status: :ok }
        format.json { render json: { data: @invoices }, status: :ok }
      end
      return
    else
      if filter_type == "date"
        @invoices = Invoice.where(date: filter_value).order('created_at DESC')
        #retorno de listagem
        respond_to do |format|
          format.html { render :index, status: :ok }
          format.json { render json: { data: @invoices }, status: :ok }
        end
        return
      end
      if filter_type == "id"
        respond_to do |format|
          msg =  "Não existe invoice com este id!"
          format.html { redirect_to("/invoice/show/#{filter_value}", status: :ok) }
          format.json { render json: { head: :no_content }, status: :ok }
        end
        return
      end
    end
  end

  def show
    id = params[:id]
    if !id.present?
      respond_to do |format|
        msg =  "Parâmetros inválidos!"
        format.html { redirect_to("/invoice/list/", notice: msg, status: :unprocessable_entity) }
        format.json { render json: { notice: msg }, status: :unprocessable_entity }
      end
      return
    end
    @invoice = Invoice.find_by(id:id)
    if !@invoice.present?
      respond_to do |format|
        msg =  "Invoice não encontrado!"
        format.html { redirect_to("/invoice/list/", notice: msg, status: :unprocessable_entity) }
        format.json { render json: { notice: msg }, status: :unprocessable_entity }
      end
      return
    else
      #retorno do item
      respond_to do |format|
        format.html { render :show, status: :ok }
        format.json { render json: { data: @invoice }, status: :ok }
      end
      return
    end
  end

  def create
    if !invoice_params_create[:number].present? || !invoice_params_create[:date].present? ||
      !invoice_params_create[:company].present? || !invoice_params_create[:payer].present? ||
      !invoice_params_create[:value].present? || !invoice_params_create[:emails].present?
       respond_to do |format|
         msg =  "Parâmetros inválidos!"
         format.html { redirect_to("/invoice/list/", notice: msg, status: :unprocessable_entity) }
         format.json { render json: { notice: msg }, status: :unprocessable_entity }
       end
       return
   end

   @invoice = Invoice.new(invoice_params_create)
   @invoice.user_id = session[:current_user_id]
   respond_to do |format|
     if @invoice.save
       format.html { redirect_to("/invoice/list/", notice: "Invoice was successfully created.", status: :ok) }
       format.json { render :show, status: :ok, location: @invoice }
     else
       msg = "Dados inválidos!"
       format.html { redirect_to("/invoice/list/", status: :unprocessable_entity) }
       format.json { render json: { notice: msg }, status: :unprocessable_entity }
     end
   end
   return
  end

  def update
    if !invoice_params_update[:id].present? ||
      !invoice_params_update[:number].present? || !invoice_params_update[:date].present? ||
      !invoice_params_update[:company].present? || !invoice_params_update[:payer].present? ||
      !invoice_params_update[:value].present? || !invoice_params_update[:emails].present?
       respond_to do |format|
         msg =  "Parâmetros inválidos!"
         format.html { redirect_to("/invoice/list/", status: :unprocessable_entity) }
         format.json { render json: { notice: msg }, status: :unprocessable_entity }
       end
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
end
