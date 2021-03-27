class Item < ActiveRecord::Base

after_save :update_topic_timestamp

def update_topic_timestamp
  if self.topic_id then
  t=self.topic
  t.last_updated=DateTime.current() 
  t.save
  end
end 

def subtopic
  if self.item_type=='topic' then
    topic=Topic.find_by_id(self.item_id)
  else 
    topic=nil
  end
  topic
end
def file
  if self.item_type=='file' then
    file=Uploadedfile.find_by_id(self.item_id)
  else 
    file=nil
  end
  file
end
def image
  if self.item_type=='image' then
    image=Image.find_by_id(self.item_id)
  else 
    image=nil
  end
  image
end
def post
  if self.item_type=='post' then
    post=Post.find_by_id(self.item_id)
  else 
    post=nil
  end
  post
end
def topic
  topic=Topic.find_by_id(self.topic_id)
end

def end_item_path
  #path='/'+self.item_type+'s/'+self.item_id.to_s
  if self.topic_id then 
   path='/topics/'+self.topic_id.to_s
  end
end

def end_item
  enditem=nil
  if self.item_type=='file' then
    enditem=Uploadedfile.find_by_id(self.item_id)
  elsif self.item_type=='image' then
    enditem=Image.find_by_id(self.item_id)
  elsif self.item_type=='post' then
    enditem=Post.find_by_id(self.item_id)
  elsif self.item_type=='topic' then
    enditem=Topic.find_by_id(self.item_id)
  end
  enditem
end

# Sends email
def send_emails
if self.topic_id then
if ENV["RAILS_ENV"] == "production" then
    subs=UserTopicLink.where(:topic_id => self.topic_id)
    subs.each do |sub|
      @user=User.find_by_id(sub.user_id)
      UserMailer.subscriber_mail(self,@user).deliver
    end
end
end
end

end
