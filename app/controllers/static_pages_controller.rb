class StaticPagesController < ApplicationController

  def home
       @static_page=true
       @items=Item.find_by_sql [ "select * from items order by updated_at desc limit 20 " ]
  end

  def about
  end

end
