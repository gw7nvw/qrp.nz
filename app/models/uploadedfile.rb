class Uploadedfile < ActiveRecord::Base
has_attached_file :image,
:path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
:url => "/system/:attachment/:id/:basename_:style.:extension"

validates_attachment :image,
    :presence => true
validates_attachment_content_type :image, :content_type =>[
             "application/pdf",
             "application/vnd.ms-excel",
             "application/vnd.ms-office",
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
             "application/vnd.oasis.opendocument.spreadsheet",
             "application/msword", 
             "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
             "text/plain"],
             :message => ', Only .PDF, .XLS, .DOC, .ODS, .ODT or .TXT files are allowed. '

after_save :update_item

def update_item
  i=self.item
  if i then
    i.touch
    i.save
  end
end

def updated_by_name
  user=User.find_by_id(self.updated_by_id)
  if user then user.callsign else "" end
end

def topic_name
   topic=Topic.find_by_id(topic_id())
   if topic then topic.name else "" end
end

def topic
   topic=Topic.find_by_id(topic_id())
end

def topic_id
  topic=nil
  item=self.item
  if item then
     topic=item.topic_id
  end
  topic
end

def item
  item=nil
  items=Item.find_by_sql [ "select * from items where item_type='file' and item_id="+self.id.to_s ]
  if items then
     item=items.first
  end
  item
end

end
