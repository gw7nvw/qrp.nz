class Contest < ActiveRecord::Base
  belongs_to :contest_series, class_name: "ContestSeries"
  validates :contest_series_id,  presence: true


def hours
  hours=(self.end_time-self.start_time)/3600
end

def contacts
  contacts=Contact.where(:contest_id => self.id)
end

def contest_logs
  contest_logs=ContestLog.where(contest_id: self.id)
end

def points(callsign)
    points=0

    logs=ContestLog.find_by_sql [ " select * from contest_logs where contest_id = "+self.id.to_s+" and callsign='"+callsign+"';" ]
    logs.each do |l|
      points+=l.points
    end
    points
end

def hour_points(hour,callsign)
    points=0

    logs=ContestLog.find_by_sql [ " select * from contest_logs where contest_id = "+self.id.to_s+" and callsign='"+callsign+"';" ]
    logs.each do |l|
      points+=l.hour_points(hour)
    end
    points
end

def local_start_date(current_user)
   t=nil
   if self.start_time then t=self.start_time.strftime('%d/%m/%Y') end
   t
 end
def local_end_date(current_user)
   t=nil
   if self.end_time then t=self.end_time.strftime('%d/%m/%Y') end
   t
 end

def local_start_time(current_user)
   t=nil
   if self.start_time then t=self.start_time.strftime('%H:%M') end
   t
 end
 def local_end_time(current_user)
   t=nil
   if self.end_time then t=self.end_time.strftime('%H:%M') end
   t
 end

def logs
  logs=ContestLog.where(contest_id: self.id)
end

def validate_all
  cls=self.contest_logs
  cls.each do |cl|
     cl.validate_all
  end
end

end
