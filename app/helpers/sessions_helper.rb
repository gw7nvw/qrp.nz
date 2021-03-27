module SessionsHelper

  def sign_in(user)
    remember_token = User.new_token
    cookies[:remember_token2] = {value: remember_token, expires: 1.month.from_now.utc, domain: 'qrp.nz'}
    user.update_attribute(:remember_token, User.digest(remember_token))
    self.current_user = user
    session[:user_id]=user.id
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_token))
    cookies.delete(:remember_token2, domain: 'qrp.nz')
    self.current_user = nil
    session[:user_id]=nil

  end

  def signed_in?
    !current_user.nil?
  end
  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token2])
    @current_user ||= User.find_by(remember_token: remember_token)
    @current_user
  end
end

