class ContestLogsController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :editgrid]
skip_before_filter :verify_authenticity_token, :only => [:save]

def show
  @contest_log = ContestLog.find_by_id(params[:id])
  if !@contest_log then
    redirect_to '/'
  end

end

def load

end

def save
    status=200
    data=params[:data]
    id=params[:id]
    cl=ContestLog.find_by_id(id)
    ids=[]
    data.each do |row|
      id=row[16]
      if id and id>=1 then
        cle=ContestLogEntry.find_by_id(id)
        cle.rownum=row[0]
      else
        cle=ContestLogEntry.new
      end
      if row[2] then 
      cle.time=("%05.2f" % (((row[1]||"").gsub(/\D/,'').to_f)/100)).gsub('.',':')
      cle.callsign=(row[2]||"").upcase
      cle.is_qrp=row[3]
      cle.is_portable=row[4]
      cle.is_backcountry=row[5]
      cle.is_dx=row[6]
      cle.mode=row[7]
      cle.band=row[8]
      cle.name=row[9]
      cle.location=row[10]
      cle.rst_sent=row[11]
      cle.index_sent=row[12] 
      cle.rst_recd=row[13]
      cle.index_recd=row[14]
      cle.contest_log_id=cl.id
      if !cle.save then status=500 else 
         cle.calc_points=cle.points
         cle.save
      end
      ids << cle.id
      end
    end
    #delete entries not in our post
    @contacts=ContestLogEntry.where(contest_log_id: cl.id) 
    @contacts.each do |contact|
      if !(ids.include? contact.id)  then contact.destroy end
    end
    @contacts=ContestLogEntry.where(contest_log_id: cl.id).order(:rownum)

    ContestLogEntry.add_row_ids(cl.id)
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @contacts, status: status }
    end

end

def new
  if signed_in? then
    @contests=Contest.where(is_active: true)
    @contest_log=ContestLog.new
    if params[:contest_id] then 
     @contest_log.contest_id=params[:contest_id]
     @contest_log.date=@contest_log.contest.start_time
    end
    @contest_log.callsign=current_user.callsign
    @contest_log.fullname=(current_user.firstname||"")+" "+(current_user.lastname||"")
  else
    redirect_to '/'
  end
end

def edit
  @contest_log = ContestLog.find(params[:id])
  @contests=Contest.where(is_active: true)
  @contest=Contest.find(@contest_log.contest_id)
  @user=User.find_by(callsign: @contest_log.callsign)
  @contacts = ContestLogEntry.where(contest_log_id: @contest_log.id).order(:rownum)
#  if !@contacts or @contacts.count==0 then @contacts=[ContestLogEntry.new] end
end

def create
  if signed_in?  then
    if params[:commit] then
      @contest_log = ContestLog.new(contest_log_params)
      if @contest_log.save then
        @contest_log.reload
        @id=@contest_log.id
        params[:id]=@id
        @contests=Contest.where(is_active: true)
        @contest=Contest.find(@contest_log.contest_id)
        @user=User.find_by(callsign: @contest_log.callsign)
        redirect_to '/contest_logs/'+@id.to_s+'/edit'
        @contest_log.post_notification
      else
        @contests=Contest.where(is_active: true)
        render 'new'
      end
    else
      redirect_to '/'
    end
  else 
  redirect_to '/'
  end
end

def delete
  if signed_in?  then
   cl=ContestLog.find_by_id(params[:id])
   if cl then contest_id=cl.contest_id
     if cl.callsign==current_user.callsign or current_user.is_admin then
       cl.contacts.each do |cle|
         cle.destroy
       end
       cl.destroy
       flash[:success]="Contest log deleted"
     end
    
     if contest_id and contest_id>0 then redirect_to '/contests/'+contest_id.to_s else redirect_to '/' end
    end
  else
    redirect_to '/'
  end
end

def update
  if signed_in?  then
    if params[:commit] then
      if !(@contest_log = ContestLog.find_by_id(params[:id]))
          flash[:error] = "Log does not exist: "+@log.id.to_s
          redirect_to '/'
      end
      @contest_log.assign_attributes(contest_log_params)

      if @contest_log.save then
        flash[:success] = "Log details updated"
        @contests=Contest.where(is_active: true)
        @contest=Contest.find(@contest_log.contest_id)
        @user=User.find_by(callsign: @contest_log.callsign)
        @contacts = ContestLogEntry.where(contest_log_id: @contest_log.id).order(:rownum)
        redirect_to '/contest_logs/'+@contest_log.id.to_s+'/edit'
      else
        @contests=Contest.where(is_active: true)
        @contest=Contest.find(@contest_log.contest_id)
        @user=User.find_by(callsign: @contest_log.callsign)
        @contacts = ContestLogEntry.where(contest_log_id: @contest_log.id).order(:rownum)
        redirect_to '/contest_logs/'+@contest_log.id.to_s+'/edit'
      end
    else
      redirect_to '/'
    end
  else
    redirect_to '/'
  end

end

  def post_notification(contest_log)
    if contest_log and contest_log.contest then
      details=contest_log.callsign+" added a log for "+contest_log.contest.name+"  on "+contest_log.localdate(current_user)

      hp=HotaPost.new
      hp.title=details
      hp.url="qrp.nz/contest_logs/"+contest_log.id.to_s
      hp.save
      hp.reload
      i=Item.new
      i.item_type="hota"
      i.item_id=hp.id
      i.save
    end
  end


private
  def contest_log_params
    params.require(:contest_log).permit(:id, :location, :callsign, :fullname, :contest_id, :date, :power, :antenna, :hut_id, :park_id, :island_id, :is_qrp, :is_portable,:band,:rownum, :is_backcountry)
  end
end
