class UserController < ApplicationController

  #gerar tokens
  def token

    #recebe email de param
    email = params[:email]
    if !email.present?
      #retorna msg de erro
      return_response(url_redirect: root_path+"?error_id=1", msg: "E-mail não enviado", status: :unprocessable_entity)
      return
    end

    #new object service to user
    user_service = UserService.new

    #verifica a existencia do email na base
    user = user_service.find_user_by_email(email: email)

    if !user.present?
      #inclui
      user = user_service.new_user(email: email)
    else

      #verifica se já existe token
      if user_service.has_token?(user: user)
        #recebe param que verifica se quer regerar
        update = params[:update]
        if !update
          #responde informando que já existe token
          msg =  "Já existe token para este e-mail. Você deseja regerar o token?"
          return_response(url_redirect: root_path+"?error_id=2", msg: msg, status: :unprocessable_entity)
          return
        else
          #caso contrario, é porque já recebeu esta info e deseja regerar
          user_service.generate_token(user: user)
        end
      else
        #caso o token não exista, gera o token temporario
        user_service.generate_token(user: user)
      end
    end

    # responde: informe que o usuário precisará acessar o email dele.
    msg =  "Seu token foi regerado. Você precisará acessar o email para ativar o token e fazer login."
    return_response(url_redirect: root_path, msg: msg, status: :ok)
    return

  end

  def activate

    #recebe email e token de param
    email = params[:email]
    token = params[:token]

    if !email || !token
      # params invalids
      msg =  "Parâmetros inválidos!"
      return_response(url_redirect: root_path, msg: msg, status: :unprocessable_entity)
      return
    end

    #new object service to user
    user_service = UserService.new


    #verifica a existencia do email na base
    user = user_service.find_user_by_email_and_token(email: email, value: token)

    if !user.present?
      # se token é invalido, devolve msg
      msg =  "Este token é inválido!"
      return_response(url_redirect: root_path, msg: msg, status: :unprocessable_entity)
    else
      #ativa o token
      user_service.activate_token(user: user)

      #efetua login do usuario
      session[:current_user_id] = user.id
      msg =  "O token foi ativado!"
      return_response(url_redirect: root_path, msg: msg, status: :ok)
    end
  end

  def login
    #recebe token de param
    token = params[:token]
    if !token
      # params invalids
      msg =  "Parâmetros inválidos!"
      return_response(url_redirect: root_path, msg: msg, status: :unprocessable_entity)
      return
    end

    #new object service to user
    user_service = UserService.new

    user = user_service.find_user_by_token(value: token)

    if !user.present?
      # se token é invalido, devolve msg
      msg =  "Este token é inválido!"
      return_response(url_redirect: root_path, msg: msg, status: :unprocessable_entity)
    else
      #efetua login do usuario
      session[:current_user_id] = user.id
      msg =  "O login foi realizado corretamente!"
      return_response(url_redirect: "/invoice/list", msg: msg, status: :ok)
    end
  end

  def logout
    session.delete(:current_user_id)
    msg =  "O usuário foi deslogado!"
    return_response(url_redirect: root_path, msg: msg, status: :ok)
  end

  private

  def return_response(url_redirect:, msg:, status:)
    respond_to do |format|
      format.html { redirect_to(url_redirect, notice: msg, status: status) }
      format.json { render json: { notice: msg }, status: status }
    end
    return
  end

end
