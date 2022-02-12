class UserController < ApplicationController

  #gerar tokens
  def token

    #recebe email de param
    email = params[:email]
    if !email.present?
      #retorna msg de erro
      respond_to do |format|
        msg =  "E-mail não enviado"
        format.html { redirect_to(root_path+"?error_id=1", notice: msg, status: :unprocessable_entity)}
        format.json { render json: { error_id: 1, notice: msg }, status: :unprocessable_entity }
      end
      return
    end

    #verifica a existencia do email na base
    user = User.where(email: email).take
    if !user.present?
      #inclui
      token = generate_token
      user = User.create(email: email, token_temp: token)
    else
      #verifica se já existe token
      if user.token_main.present?
        #recebe param que verifica se quer regerar
        update = params[:update]
        if !update
          #responde informando que já existe token
          respond_to do |format|
            msg =  "Já existe token para este e-mail. Você deseja regerar o token?"
            format.html { redirect_to(root_path+"?error_id=2", notice: msg, status: :unprocessable_entity) }
            format.json { render json: { error_id: 2, notice: msg }, status: :unprocessable_entity }
          end
          return
        else
          #caso contrario, é porque já recebeu esta info e deseja regerar
          user.token_temp = generate_token
          user.save
        end
      else
        #caso o token não exista, gera o token temporario
        user.token_temp = generate_token
        user.save
      end
    end

    # envia email para usuário ativar o token e logar
    send_mail_token(user.email, user.token_temp)

    # responde: informe que o usuário precisará acessar o email dele.
    respond_to do |format|
      msg =  "Seu token foi regerado. Você precisará acessar o email para ativar o token e fazer login."
      format.html { redirect_to(root_path, notice: msg, status: :ok) }
      format.json { render json: { notice: msg }, status: :ok }
    end

  end

  def activate

    #recebe email e token de param
    email = params[:email]
    token = params[:token]

    if !email || !token
      # params invalids
      respond_to do |format|
        msg =  "Parâmetros inválidos!"
        format.html { redirect_to(root_path, notice: msg, status: :unprocessable_entity) }
        format.json { render json: { notice: msg }, status: :unprocessable_entity }
      end
      return;
    end

    user = User.where(email: email, token_temp: token).take
    if !user.present?
      # se token é invalido, devolve msg
      respond_to do |format|
        msg =  "Este token é inválido!"
        format.html { redirect_to(root_path, notice: msg, status: :unprocessable_entity) }
        format.json { render json: { notice: msg }, status: :unprocessable_entity }
      end
      return
    else
      #ativa o token
      user.update(token_main: user.token_temp, token_temp: nil)
      #efetua login do usuario
      session[:current_user_id] = user.id
      respond_to do |format|
        msg =  "O token foi ativado!"
        format.html { redirect_to(root_path, notice: msg, status: :ok) }
        format.json { render json: { notice: msg }, status: :ok }
      end
      return
    end
  end

  def login
    #recebe token de param
    token = params[:token]
    if !token
      # params invalids
      respond_to do |format|
        msg =  "Parâmetros inválidos!"
        format.html { redirect_to(root_path, notice: msg, status: :unprocessable_entity) }
        format.json { render json: { notice: msg }, status: :unprocessable_entity }
      end
      return
    end

    user = User.where(token_main: token).take
    if !user.present?
      # se token é invalido, devolve msg
      respond_to do |format|
        msg =  "Este token é inválido!"
        format.html { redirect_to(root_path, notice: msg, status: :unprocessable_entity) }
        format.json { render json: { notice: msg }, status: :unprocessable_entity }
      end
      return
    else
      #efetua login do usuario
      session[:current_user_id] = user.id
      respond_to do |format|
        msg =  "O login foi realizado corretamente!"
        format.html { redirect_to("/invoice/list", notice: msg, status: :ok) }
        format.json { render json: { notice: msg }, status: :ok }
      end
      return
    end
  end

  def logout
    session.delete(:current_user_id)
    respond_to do |format|
      msg =  "O usuário foi deslogado!"
      format.html { redirect_to(root_path, notice: msg, status: :ok) }
      format.json { render json: { notice: msg }, status: :ok }
    end
    return
  end

  private

  def generate_token
    rand(36**8).to_s(36)
  end

  def send_mail_token(email, token)
    # Sendo que nesse email deverá ter um link para ativar o token
    # e logar o usuário em seguida.
    #....
  end
end
