class Park < ActiveRecord::Base
  establish_connection "hota"
  def code
    code="ZLP/"+self.id.to_s.rjust(7,'0')
  end

  def codename
    codename=self.code+" - "+self.name
  end

end
