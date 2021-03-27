class ContestLogEntry < ActiveRecord::Base


def contest_log
  cl=ContestLog.find_by_id(self.contest_log_id)
end

def self.add_row_ids(contest_log_id)
  if contest_log_id then
    rowid=1
    cles=ContestLogEntry.where(contest_log_id: contest_log_id).order(:index_sent) 
    cles.each do |cle|
      cle.rownum=rowid
      cle.save
      rowid+=1
    end
  end
end

def validated_against_log
  cle=ContestLogEntry.find_by_id(self.validated_against)
  if cle then cle.contest_log_id else "" end
end

def points
  cs=self.contest_log.contest.contest_series

  pass=true
  points=0
  if !(self.name and self.name.length>0) then pass=false; puts "Fail name" end
  if !(self.callsign and self.callsign.length>0) then pass=false; puts "Fail callsign" end
  if !(self.time and self.time.length>0) then pass=false; puts "Fail time" end
  if cs.include_qth and !(self.location and self.location.length>0) then pass=false; puts "Fail location" end
  if cs.include_rst and !(self.rst_sent and self.rst_sent>0) then pass=false; puts "Fail rst_sent" end
  if cs.include_rst and !(self.rst_recd and self.rst_recd>0) then pass=false; puts "Fail rst_recd" end
  if cs.include_index and !(self.index_sent and self.index_sent>0) then pass=false; puts "Fail index_sent" end
  if cs.include_index and !(self.index_recd and self.index_recd>0) then pass=false; puts "Fail index_recd" end
  if cs.include_freq and !(self.band and self.band.to_s.length>0) then pass=false; puts "Fail freq"  end

 puts "PASS: "+pass.to_s
  if pass==true then 
    points=cs.base_points
    #qrp
    if self.is_qrp then points+=cs.qrp_points end
    #portable
    if self.is_portable then points+=cs.portable_points end
    if self.is_backcountry then points+=cs.backcountry_points end
    if self.contest_log.is_portable then points+=cs.portable_points end
    if self.contest_log.is_backcountry then points+=cs.backcountry_points end
    #cw
    if self.mode=="CW" then points+=cs.cw_points end
    #dx
    if self.is_dx then points+=cs.dx_points end
    if self.is_valid then points+=cs.valid_points end
  end
 
  points
end

def validate
  cles=ContestLogEntry.find_by_sql [ " select cle.* from contest_log_entries cle inner join contest_logs cl on cl.id = cle.contest_log_id where cle.callsign='"+self.contest_log.callsign+"' and cl.callsign='"+self.callsign+"' and cl.contest_id="+self.contest_log.contest_id.to_s+" and cle.mode='"+self.mode+"'  and split_part(time,':',1)='"+self.time.split(':')[0]+"'" ]
  if cles and cles.count==1 then
     cle=cles.first
     valid=true
     if self.index_sent.to_i!=cle.index_recd.to_i then puts "CLV: index_sent";self.index_sent_valid=false else self.index_sent_valid=true end 
     if self.index_recd.to_i!=cle.index_sent.to_i then valid=false;puts "CLV: index_recd";self.index_recd_valid=false else self.index_recd_valid=true end
     if self.rst_sent.to_i!=cle.rst_recd.to_i then puts "CLV: rst_sent";self.rst_sent_valid=false else self.rst_sent_valid=true end
     if self.rst_recd.to_i!=cle.rst_sent.to_i then valid=false;puts "CLV: rst_recd";self.rst_recd_valid=false else self.rst_recd_valid=true end
     #if (self.contest_log.is_qrp==true)!=(cle.is_qrp==true) then valid=false;puts "CLV: is_qrp1"end
     if (self.is_qrp==true)!=(cle.contest_log.is_qrp==true) then valid=false;puts "CLV: is_qrp2";self.qrp_valid=false else self.qrp_valid=true end
     #if (self.contest_log.is_portable==true)!=(cle.is_portable==true) then valid=false;puts "CLV: is_portable1" end
     if (self.is_portable==true)!=(cle.contest_log.is_portable==true) then valid=false;puts "CLV: is_portable2";self.portable_valid=false else self.portable_valid=true end
     if self.time.to_time<cle.time.to_time-60 or self.time.to_time>cle.time.to_time+60 then valid=false;self.time_valid=false else self.time_valid=true end
     if (self.is_backcountry==true)!=(cle.contest_log.is_backcountry==true) then valid=false;puts "CLV: is_backcountry2";self.backcountry_valid=false else self.backcountry_valid=true end
     if valid==true then
        self.is_valid=true
#        cle.is_valid=true
        puts "CLV: Validity confirimed"
     else
        self.is_valid=false
#        cle.is_valid=false
        puts "CLV: Validity check failed"
     end
     self.validated_against=cle.id
#     cle.validated_against=self.id
     self.save
#     cle.save
  else
     puts "CLV: No match"
  end 
end

def other_party
  if self.validated_against then op=ContestLogEntry.find_by_id(self.validated_against) else op=nil end
  op
end
end

