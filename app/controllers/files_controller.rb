class FilesController < ApplicationController


before_action :signed_in_user, only: [:delete, :create, :update]

def index
#    @fulluploadedfiles=Uploadedfile.all.order(:last_updated)
#    @uploadedfiles=@fulluploadedfiles.paginate(:per_page => 20, :page => params[:page])
    redirect_to '/topics'
end

def show
    @uploadedfile=Uploadedfile.find_by_id(params[:id])
    if @uploadedfile then
      @topic=@uploadedfile.topic
      @items=@topic.items
      render 'topics/show' 
    else
      flash[:error]="Sorry - the topic or post that you tried to view no longer exists"
      redirect_to '/'
    end

end


def new
    @uploadedfile=Uploadedfile.new
    @topic=Topic.find_by_id(params[:topic_id])
    if !@topic then 
      redirect_to '/'
    end
    @submit_button="Create File"
end

def edit
    if params[:referring] then @referring=params[:referring] end

    if(!(@uploadedfile = Uploadedfile.where(id: params[:id]).first))
      redirect_to '/'
    end
    @topic=Topic.find_by_id(@uploadedfile.topic_id)
    @submit_button="Save Changes"
end

def delete
 if signed_in?  then
    @uploadedfile=Uploadedfile.find_by_id(params[:id])
    if @uploadedfile and (current_user.is_admin or (current_user.id==@uploadedfile.created_by_id)) then
      @item=@uploadedfile.item
      if @item then @item.destroy end
      if @uploadedfile.destroy
        flash[:success] = "File deleted, id:"+params[:id]
        redirect_to '/'

      else
        flash[:error] = "Failed to delete file"
        redirect_to '/'
      end
    else
      flash[:error] = "Failed to delete file"
      redirect_to '/'
    end
  else
    flash[:error] = "Failed to delete file"
    redirect_to '/'
  end
end

def update
 if signed_in?  then
    @uploadedfile=Uploadedfile.find_by_id(params[:id])
    old_uploadedfile=@uploadedfile.dup
    topic=@uploadedfile.topic
    if @uploadedfile and (current_user.is_admin or (current_user.id==@uploadedfile.created_by_id)) then
      if params[:commit]=="Delete File" then
         item=@uploadedfile.item
         item.destroy
         if @uploadedfile.destroy
           flash[:success] = "File deleted, id:"+params[:id]
           @topic=topic 
           @items=topic.items
           render 'topics/show'
         else
           flash[:error] = "Failed to delete file"
           edit()
           render 'edit'
         end
       else
         @uploadedfile.assign_attributes(uploadedfile_params)
         #if no new file uploaded keep old one
         if(!@uploadedfile.image) then @uploadedfile.image=old_uploadedfile.image end
         @uploadedfile.updated_by_id=current_user.id
         if @uploadedfile.save then
           flash[:success] = "File updated"

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
      @uploadedfile=Uploadedfile.new(uploadedfile_params)

      @uploadedfile.created_by_id = current_user.id #current_user.id
      @uploadedfile.updated_by_id = current_user.id #current_user.id
      @topic.last_updated = Time.now

      if @uploadedfile.save
        item=Item.new
        item.topic_id=@topic.id
        item.item_type="file"
        item.item_id=@uploadedfile.id
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
        flash[:error] = "Error creating uploadedfile"
        @edit=true
        render 'new'
      end
    else
      redirect_to '/'
    end

end

  private
  def uploadedfile_params
    params.require(:uploadedfile).permit(:title, :description, :image)
  end

end
