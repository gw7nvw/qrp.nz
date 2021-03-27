class HotaPost < ActiveRecord::Base
def item
  item=nil
  items=Item.find_by_sql [ "select * from items where item_type='hota' and item_id="+self.id.to_s ]
  if items then
     item=items.first
  end
  item
end

end
