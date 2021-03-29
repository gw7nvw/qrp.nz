class Island < ActiveRecord::Base
  establish_connection "hota"
  def code
    code="ZLI/"+self.id.to_s.rjust(5,'0')
  end

  def codename
    codename=self.code+" - "+self.name
  end

end
