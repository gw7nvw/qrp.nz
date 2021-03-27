class SessionsController < ApplicationController
include SessionsHelper

  def new
#    key = OpenSSL::PKey::RSA.new(1024)
#    @public_modulus  = key.public_key.n.to_s(16)
#    @public_exponent = key.public_key.e.to_s(16)
#    session[:key] = key.to_pem

  end

  def create
#  key = OpenSSL::PKey::RSA.new(session[:key])

  password=params[:session][:password] 
  user = User.find_by(email: params[:session][:email].downcase)
  if !user then  user = User.find_by(callsign: params[:session][:email].upcase) end

  if user && user.authenticate(password)
      if user.activated?
        sign_in user
        if params[:referring_url] then referring_url=params[:referring_url] else referring_url="/" end
        if params[:signin_x] and params[:signin_y] and params[:signin_zoom] then
          redirect_to referring_url+"?x="+params[:signin_x]+"&y="+params[:signin_y]+"&zoom="+params[:signin_zoom]
        else
          redirect_to referring_url
        end
      else
        message  = "Account not registered. "
        message += "Please use the sign up link to register this callsign."
        message += "Alternatively email mattbriggs@yahoo.com to request manual activation"

        flash[:error] = message
        render 'new'
      end
    # Sign the user in and redirect to the user's show page.
  else
      flash.now[:error] = 'Invalid user/password combination'
      new()
      render 'new'
  end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end

