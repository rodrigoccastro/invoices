class UserController < ApplicationController

  #generate tokens
  def token

    #receive email by param
    email = params[:email]
    if !email.present?
      #return error
      return_response(url_redirect: root_path+"?error_id=1", msg: "E-mail not present", status: :unprocessable_entity)
      return
    end

    #new object service to user
    user_service = UserService.new

    #verify existence of email in database
    user = user_service.find_user_by_email(email: email)

    if !user.present?
      # add
      user = user_service.new_user(root_path: root_path, email: email)
    else

      # verify if has token
      if user_service.has_token?(user: user)
        #recieve param for verify if regenerate token
        update = params[:update]
        if !update
          #return with message: token exist, do you want regenerate token?
          msg =  "This email has token. Do you want regenerate token?"
          return_response(url_redirect: root_path+"?error_id=2", msg: msg, status: :unprocessable_entity)
          return
        else
          #other way, the user, before, recieve token and want regenerate
          user_service.generate_token(user: user)
        end
      else
        #if token not exist, generate token temp
        user_service.generate_token(user: user)
      end
    end

    # return message: the user need access your email
    msg =  "Your token was regenerated. You need access your email for activate your token and login."
    return_response(url_redirect: root_path, msg: msg, status: :ok)
    return

  end

  def activate

    #recieve email and token by params
    email = params[:email]
    token = params[:token]

    if !email || !token
      # params invalids
      msg =  "Params invalids!"
      return_response(url_redirect: root_path, msg: msg, status: :unprocessable_entity)
      return
    end

    #new object service to user
    user_service = UserService.new


    #verify if exists email in database
    user = user_service.find_user_by_email_and_token(email: email, value: token)

    if !user.present?
      # if token is invalid, return msg
      msg =  "This token is invalid!"
      return_response(url_redirect: root_path, msg: msg, status: :unprocessable_entity)
    else
      # activate token
      user_service.activate_token(user: user)

      # do login for user
      session[:current_user_id] = user.id
      msg =  "This token was activated!"
      return_response(url_redirect: root_path, msg: msg, status: :ok)
    end

  end

  def login

    # recieve token by param
    token = params[:token]
    if !token
      # params invalids
      msg =  "Params invalids!"
      return_response(url_redirect: root_path, msg: msg, status: :unprocessable_entity)
      return
    end

    #new object service to user
    user_service = UserService.new

    user = user_service.find_user_by_token(value: token)

    if !user.present?
      # if token is invali, return msg
      msg =  "This token is invalid!"
      return_response(url_redirect: root_path, msg: msg, status: :unprocessable_entity)
    else
      # do login for user
      session[:current_user_id] = user.id
      msg =  "Login successfully!"
      return_response(url_redirect: "/invoice/list", msg: msg, status: :ok)
    end

  end

  def logout
    session.delete(:current_user_id)
    msg =  "The user has been logged out!"
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
