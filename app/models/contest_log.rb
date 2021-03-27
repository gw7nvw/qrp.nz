class ContestLog < ActiveRecord::Base
  validates :callsign,  presence: true
  validates :fullname,  presence: true
  validates :date,  presence: true
  validates :power,  presence: true
  validates :antenna,  presence: true
  validates :location,  presence: true
  validates :contest_id,  presence: true

  belongs_to :park, class_name: "Park"
  belongs_to :island, class_name: "Island"
  belongs_to :hut, class_name: "Hut"
  belongs_to :contest, class_name: "Contest"

def user
  user=User.find_by(callsign: self.callsign)
end

def local_date
   t=nil
   if self.date then t=self.date.strftime('%d/%m/%y') end
   t
 end

def contacts
  contacts=ContestLogEntry.where(contest_log_id: self.id).order('id')
end

def points
   points=0
   if self.baseline then points=self.baseline.points end
   self.contacts.each do |c|
     points+=c.points
   end
   points
end

def hour_points(thehour)
   points=0
   hour_start=self.contest.start_time.in(thehour.hour).strftime('%H:%M')
   hour_end=self.contest.start_time.in((thehour+1).hour).strftime('%H:%M')
   if self.baseline then points=self.baseline.points end
   self.contacts.where('time >= ? and time < ?', hour_start, hour_end ).each do |c|
     points+=c.points
   end
   points
end

def baseline
  baseline=nil
  baselines=ContestLogBaseline.where(contest_id: self.id)
  if baselines and baselines.count>0 then baseline=baselines.first end
  baseline
end

def self.import(sheet, contest_id)
  if sheet.row(1)[0][0..22]=="GO QRP Nights Log Sheet" then
    cl=ContestLog.new
    cl.location=sheet.row(3)[10]
    cl.fullname=sheet.row(3)[14]
    cl.callsign=if sheet.row(3)[2] then sheet.row(3)[2].upcase.strip else "" end
    cl.date=sheet.row(3)[7]
    cl.power=sheet.row(4)[14]
    cl.antenna=sheet.row(5)[2]
    cl.is_qrp=if sheet.row(4)[2]=="y" or sheet.row(4)[2]=="Y" then true else false end 
    cl.is_portable=if sheet.row(4)[7]=="y" or sheet.row(4)[7]=="Y" then true else false end 
    cl.is_backcountry=if sheet.row(4)[10]=="y" or sheet.row(4)[10]=="Y" then true else false end 
    cl.contest_id=contest_id
    count=0
    if cl.save then
      cl.reload
      rownum=1
      sheet.each do |row|
        count+=1
        if count>=9 and row[1] and row[2] and row[12] and row[14] then
          cle=ContestLogEntry.new
          cle.time=("%05.2f" % (((row[1]||"").gsub(/\D/,'').to_f)/100)).gsub('.',':')
          cle.callsign=row[2].upcase.strip
          cle.is_qrp=if row[3]=='y' or row[3]=='Y' then true else false end
          cle.is_portable=if row[4]=='y' or row[4]=='Y' then true else false end
          cle.is_backcountry=if row[5]=='y' or row[5]=='Y' then true else false end
          cle.is_dx=if row[6]=='y' or row[6]=='Y' then true else false end
          cle.mode=if row[7]=='y' or row[7]=='Y' then 'CW' else 'Phone' end
          cle.band=row[8]
          cle.name=row[9].capitalize
          cle.location=row[10]
          cle.rst_sent=row[11].to_s.gsub(/[^0-9]/, '')
          cle.index_sent=row[12].to_s.gsub(/[^0-9]/, '')
          cle.rst_recd=row[13].to_s.gsub(/[^0-9]/, '')
          cle.index_recd=row[14].to_s.gsub(/[^0-9]/, '')
          cle.contest_log_id=cl.id
          cle.rownum=rownum
          if !cle.save then 
            puts "Error saving CLE" 
          else
            cle.calc_points=cle.points
            cle.save
            rownum+=1
          end
        end
      end
 
    end
  end
  cl 
end

  def post_notification
    if self and self.contest then
      details=self.callsign+" added a log for "+self.contest.name+"  on "+self.local_date

      hp=HotaPost.new
      hp.title=details
      hp.url="qrp.nz/contest_logs/"+self.id.to_s
      hp.save
      hp.reload
      i=Item.new
      i.item_type="hota"
      i.item_id=hp.id
      i.save
    end
  end

def validate_all
  cles=self.contacts
  cles.each do |cle|
     cle.validate
  end
end

end
