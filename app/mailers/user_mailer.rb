class UserMailer < ActionMailer::Base
  helper ApplicationHelper 
  default from: "qrp_nz@qrp.nz"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
  def new_password(user)
    @user = user
    mail to: user.email, subject: "Welcome to the QRPers NZ Group website"
  end

  def address_auth(authlist)
    @authlist = authlist
    mail to: authlist.address, subject: "Address authentication"
  end

  def subscriber_mail(item,user)
    @user=user
    @item=item
    if user and user.email then
      mail to: user.email, subject: "QRP.NZ: New post from "+@item.end_item.updated_by_name+" in your followed topics" 
    end
  end
  def membership_request(qrpnzmember,email)
     @user=qrpnzmember.user
     @member=qrpnzmember
     @email=email
     mail to: @email, subject: "New QRPers NZ membership request via qrp.nz website"
  end

  def membership_request_notification(qrpnzmember, email)
     @user=qrpnzmember.user
     @member=qrpnzmember
     @email=email
     mail to: @user.email, subject: "Your QRPers NZ membership request"
  end

end
