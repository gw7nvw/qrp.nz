class Hut < ActiveRecord::Base
  establish_connection "hota"

  def code
    code="ZLH/"+self.id.to_s.rjust(4,'0')
  end

  def codename
    codename=self.code+" - "+self.name
  end
end
