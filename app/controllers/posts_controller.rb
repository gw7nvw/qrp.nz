class PostsController < ApplicationController

before_action :signed_in_user, only: [:delete, :create, :update]

def index
##    @fullposts=Post.all.order(:last_updated)
##    @posts=@fullposts.paginate(:per_page => 20, :page => params[:page])
   redirect_to '/topics'
end

def show
    @post=Post.find_by_id(params[:id])
    if @post then 
      @topic=@post.topic
      @items=@topic.items
      render 'topics/show'   
    else
      flash[:error]="Sorry - the topic or post that you tried to view no longer exists"
      redirect_to '/'
    end
end


def new
    @post=Post.new
    @topic=Topic.find_by_id(params[:topic_id])
    if params[:title] then @post.title=params[:title] end
    if !@topic then 
      redirect_to '/'
    end
end

def edit
    if params[:referring] then @referring=params[:referring] end

    if(!(@post = Post.where(id: params[:id]).first))
      redirect_to '/'
    end
    @topic=Topic.find_by_id(@post.topic_id)
end
def delete
 if signed_in?  then
    @post=Post.find_by_id(params[:id])
    topic=@post.topic
    if @post and (current_user.is_admin or (current_user.id==@post.created_by_id)) then
      @item=@post.item
      @item.destroy
      @post.files.each do |f| 
         f.destroy
      end
      @post.images.each do |f| 
         f.destroy
      end

      if @post.destroy
        flash[:success] = "Post deleted, id:"+params[:id]
        @topic=topic
        @items=topic.items
        render 'topics/show'
  
      else
        flash[:error] = "Failed to delete post"
        edit()
        render 'edit'
      end
    else 
      flash[:error] = "Failed to delete post"
      redirect_to '/'
    end
  else 
    flash[:error] = "Failed to delete post"
    redirect_to '/'
  end
end

def update
 if signed_in?  then
    @post=Post.find_by_id(params[:id])
    topic=@post.topic
    if @post and (current_user.is_admin or (current_user.id==@post.created_by_id)) then
      if params[:commit]=="Delete Post" then
         @item=@post.item
         @item.destroy
         if @post.destroy
           flash[:success] = "Post deleted, id:"+params[:id]
           @topic=topic     
           @items=topic.items
           render 'topics/show'

         else
           flash[:error] = "Failed to delete post"
           edit()
           render 'edit'
         end
       else
         @post.assign_attributes(post_params)
         @post.updated_by_id=current_user.id
         if @post.save then
           isimage=@post.is_image
           isfile=@post.is_file
           if isimage then
             @image=Image.new
             @image.image=File.open(@post.image.path,'rb')
             @image.post_id=@post.id
             if not @image.save then 
                  flash[:error]=""
                  @image.errors.full_messages.each do |e|
                     flash[:error]+=e
                     puts e
                  end
             end
             @post.image=nil
             @post.save
             end
     
           if isfile then
             @uf=Uploadedfile.new
             @uf.image=File.open(@post.image.path,'rb')
             puts "******************************"
             puts @uf.image_content_type
             puts "******************************"
             @uf.post_id=@post.id
             if not @uf.save then 
                  flash[:error]=""
                  @uf.errors.full_messages.each do |e|
                     flash[:error]+=e
                     puts e
                  end
             end
             @post.image=nil
             @post.save
           end

           flash[:success] = "Post updated"

           # Handle a successful update.
             @topic=topic
             @items=topic.items
             render 'topics/show'
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
      @post=Post.new(post_params)
      @post.created_by_id = current_user.id #current_user.id
      @post.updated_by_id = current_user.id #current_user.id
      @topic.last_updated = Time.now

      if @post.save then
        isimage=@post.is_image
        isfile=@post.is_file
        if isimage then
          puts "*****************************ISIMAGE**************************"
          @image=Image.new
          @image.image=File.open(@post.image.path,'rb')
          @image.post_id=@post.id
          if not @image.save then
                  flash[:error]=""
                  @image.errors.full_messages.each do |e|
                     flash[:error]+=e
                     puts e
                  end
          end
          @post.image=nil
          @post.save
          end
  
        if isfile then
          puts "*****************************ISFILE**************************"
          @uf=Uploadedfile.new
          @uf.image=File.open(@post.image.path,'rb')
          puts @uf.image_content_type

          @uf.post_id=@post.id
             if not @uf.save then
                  flash[:error]=""
                  @uf.errors.full_messages.each do |e|
                     flash[:error]+=e
                     puts e
                  end
             end

          @post.image=nil
          @post.save
        end
  
        item=Item.new
        item.topic_id=@topic.id
        item.item_type="post"
        item.item_id=@post.id
        item.save
        if !@post.do_not_publish then item.send_emails end

        flash[:success] = "Posted!"
        @edit=true

        @id=@topic.id
        params[:id]=@id.to_s
        @items=Item.find_by_sql [ "select * from items where topic_id="+@id.to_s+" order by updated_at desc" ]
        render 'topics/show'
      else
        flash[:error] = "Error creating post"
        @edit=true
        render 'new'
      end
    else
      redirect_to '/'
    end

end

  private
  def post_params
    params.require(:post).permit(:title, :description, :image, :do_not_publish, :referenced_date, :referenced_time, :duration)
  end

end
