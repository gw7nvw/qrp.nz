class QrpnzmembersController < ApplicationController

before_action :signed_in_user

def new
    @member = Qrpnzmember.new
    @member.user_id=current_user.id
    @user=current_user
    if params[:referring] then @referring=params[:referring] end
end

def create
    member = Qrpnzmember.new(member_params)
    member.user_id=current_user.id

    member.generate_membership_request
    as=AdminSettings.first
    if as then qrpnz_email= as.qrpnz_email else qrpnz_email="Error - no address configured" end
    flash[:success] = "Your membership request has been emailed to the NZ QRPers group coordinator. If you do not hear back from them within 1 week then please contact them directly on "+qrpnz_email
    user=current_user
    user.membership_requested=true
    user.save
    
    if params[:referring]=="hota" then 
      redirect_to 'http://ontheair.nz/users/'+current_user.callsign
    else
      redirect_to '/users/'+current_user.callsign
    end
end

  private

    def member_params
      params.require(:qrpnzmember).permit(:comments) 
    end
end
