class ContestSeries < ActiveRecord::Base

def contests
  contests=Contest.where(:contest_series_id => self.id)
end


def logs
  logs=[]
  self.contests.each do  |c|
    c.logs.each do |l|
      logs << l
    end
  end
  logs
end

def callsigns
  callsigns=[]
  self.logs.each do |l|
    if !(callsigns.include? l.callsign) then callsigns << l.callsign end
  end
  callsigns
end

def points(callsign)
    points=0
    cs=self.contests
    ids=[] 
    cs.each do |c| ids << c.id end

    logs=ContestLog.find_by_sql [ " select * from contest_logs where contest_id in ("+ids.to_s[1..-2]+") and callsign='"+callsign+"';" ]
    logs.each do |l|
      points+=l.points
    end
    points
end

def hour_points(hour,callsign)
    points=0
    cs=self.contests
    ids=[]
    cs.each do |c| ids << c.id end

    logs=ContestLog.find_by_sql [ " select * from contest_logs where contest_id in ("+ids.to_s[1..-2]+") and callsign='"+callsign+"';" ]
    logs.each do |l|
      points+=l.hour_points(hour)
    end
    points
end

end

