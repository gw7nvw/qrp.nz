class Post < ActiveRecord::Base
has_attached_file :image,
:path => ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
:url => "/system/:attachment/:id/:basename_:style.:extension"

do_not_validate_attachment_file_type :image

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

def images
  if self.id then images=Image.where(post_id: self.id) else [] end 
end

def files
  if self.id then ufs=Uploadedfile.where(post_id: self.id) else [] end
end

def is_file
    if self.image_content_type and self.image_content_type[0..10]=='application' then true else false end
end


def is_image
  if self.image_content_type and self.image_content_type[0..4]=='image' then true else false end
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
  items=Item.find_by_sql [ "select * from items where item_type='post' and item_id="+self.id.to_s ]
  if items then
     item=items.first
  end
  item
end
end
