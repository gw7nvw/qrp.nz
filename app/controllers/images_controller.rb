class ImagesController < ApplicationController


before_action :signed_in_user, only: [:delete, :create, :update]

def index
#    @fullimages=Image.all.order(:last_updated)
#    @images=@fullimages.paginate(:per_page => 20, :page => params[:page])
   redirect_to '/topics'
end

def show
    @image=Image.find_by_id(params[:id])
    if @image then
      @topic=@image.topic
      @items=@topic.items
      render 'topics/show' 
    else
      flash[:error]="Sorry - the topic or post that you tried to view no longer exists"
      redirect_to '/'
    end

end


def new
    @image=Image.new
    @topic=Topic.find_by_id(params[:topic_id])
    if !@topic then 
      redirect_to '/'
    end
end

def edit
    if params[:referring] then @referring=params[:referring] end

    if(!(@image = Image.where(id: params[:id]).first))
      redirect_to '/'
    end
    @topic=Topic.find_by_id(@image.topic_id)
end

def delete
 if signed_in?  then
    @image=Image.find_by_id(params[:id])
    if @image and (current_user.is_admin or (current_user.id==@image.created_by_id)) then
      @item=@image.item
      if @item then @item.destroy end
      if @image.destroy
        flash[:success] = "Image deleted, id:"+params[:id]
        redirect_to '/'
      else
        flash[:error] = "Failed to delete image"
        redirect_to '/'
      end
    else
      flash[:error] = "Failed to delete image"
      redirect_to '/'
    end
  else
    flash[:error] = "Failed to delete image"
    redirect_to '/'
  end
end

def update
 if signed_in?  then
    @image=Image.find_by_id(params[:id])
    old_image=@image.dup
    topic=@image.topic
    if @image and (current_user.is_admin or (current_user.id==@image.created_by_id)) then
      if params[:commit]=="Delete Image" then
         item=@image.item
         item.destroy
         if @image.destroy
           flash[:success] = "Image deleted, id:"+params[:id]
           @topic=topic
           @items=topic.items
           render 'topics/show'
         else
           flash[:error] = "Failed to delete image"
           edit()
           render 'edit'
         end
       else
         @image.assign_attributes(image_params)
         #if no new file uploaded keep old one
         if(!@image.image) then @image.image=old_image.image end
         @image.updated_by_id=current_user.id
         if @image.save then
           flash[:success] = "Image updated"

           # Handle a successful update.
           if params[:referring]=='index' then
             @topic=topic
             render 'topics/index'
           else
             render 'show'
           end
         else
           render 'edit'
         end
       end #delete or edit
     else
       redirect_to '/'
     end # do we have permissions
    else
      redirect_to '/'
    end #signed in

end

def create
    @topic=Topic.find_by_id(params[:topic_id])
    if signed_in? and @topic and (@topic.is_public or current_user.is_admin or (@topic.owner_id==current_user.id and @topic.is_owners)) then
      @image=Image.new(image_params)

      @image.created_by_id = current_user.id #current_user.id
      @image.updated_by_id = current_user.id #current_user.id
      @topic.last_updated = Time.now

      if @image.save
        item=Item.new
        item.topic_id=@topic.id
        item.item_type="image"
        item.item_id=@image.id
        item.save
        item.send_emails


        flash[:success] = "Posted!"
        @edit=true

      #render edit panel to allow user to add links (can't do in create)
        @id=@topic.id
        params[:id]=@id.to_s
        @items=Item.find_by_sql [ "select * from items where topic_id="+@id.to_s+" order by updated_at desc" ]
        render 'topics/show'
      else
        flash[:error] = "Error creating image"
        @edit=true
        render 'new'
      end
    else
      redirect_to '/'
    end

end

  private
  def image_params
    params.require(:image).permit(:title, :description, :image)
  end

end
