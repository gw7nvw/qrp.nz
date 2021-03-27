class Qrpnzmember < ActiveRecord::Base
  belongs_to :user, class_name: "User"

  def generate_membership_request
    as=AdminSettings.first
    if as then
      qrpnz_email=as.qrpnz_email

      if self.user.is_active and self.user.email then
          puts "We should generate an email to "+qrpnz_email+" requesting membership"
          UserMailer.membership_request(self,qrpnz_email).deliver
          puts "We should generate an email to "+self.user.callsign+" confirming membership request"
          UserMailer.membership_request_notification(self,qrpnz_email).deliver
      end
    else
      puts "ERROR: No QRPNZ admin email defined."
    end
  end

end
