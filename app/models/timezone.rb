class Timezone < ActiveRecord::Base
if ENV["RAILS_ENV"] == "production" then
  establish_connection "hota"
end

end
