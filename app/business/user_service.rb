class UserService

  def find_user_by_email(email:)
    User.where(email: email).take
  end

  def find_user_by_email_and_token(email:, value:)
    user = User.where(email: email, token_temp: value).take
  end

  def find_user_by_token(value:)
    user = User.where(token_main: value).take
  end

  def new_user(email:)
    user = User.create(email: email, token_temp: token)
    send_mail_token(email: user.email, value: user.token_temp)
  end

  def generate_token(user:)
    user.token_temp = token
    user.save
    send_mail_token(email: user.email, value: user.token_temp)
  end

  def has_token?(user:)
    user.token_main.present?
  end

  def activate_token(user:)
    user.update(token_main: user.token_temp, token_temp: nil)
  end

  private

  def token
    rand(36**8).to_s(36)
  end

  def send_mail_token(email:, value:)
    # Sendo que nesse email deverá ter um link para ativar o token
    # e logar o usuário em seguida.
    #....
  end

end
