class SotaPeak < ActiveRecord::Base
  establish_connection "hota"

def codename
  codename=self.summit_code+" - "+self.name
end

end
