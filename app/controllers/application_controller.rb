class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
before_filter :set_cache_headers
before_filter :load_topics
def load_topics
    @indextopics=Topic.all.order(:last_updated).reverse
end
  include SessionsHelper
  include RgeoHelper


  def signed_in_user
      redirect_to signin_url+"?referring_url="+URI.escape(request.fullpath), notice: "Please sign in." unless signed_in?
  end

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def collection_to_csv(items)
    require 'csv'
    csvtext=""
    if items and items.first then
      columns=[]; items.first.attributes.each_pair do |name, value| columns << name end
      csvtext << columns.to_csv
      items.each do |item|
         fields=[]; item.attributes.each_pair do |name, value| fields << value end
         csvtext << fields.to_csv
      end
   end
   csvtext
  end

  def update_score(callsign)

   if callsign and callsign.length>0 then
 
     user=User.find_by(callsign: callsign)
     if not user then 
       user=User.create(callsign: callsign, activated: false, password: 'dummy', password_confirmation: 'dummy')
     end
     huts=user.huts
     parks=user.parks

     user.huts_bagged=huts.uniq.count
     user.parks_bagged=parks.uniq.count

     user.save
   end
  end
end

