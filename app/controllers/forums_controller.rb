class TopicsController < ApplicationController
before_action :signed_in_user, only: [:destroy]

  def index
    @fulltopics=Topic.all.order(:last_updated)
    @topics=@fulltopics.paginate(:per_page => 20, :page => params[:page])

  end

  def show
    @topic=Topic.find_by_id(params[:id])
    @items=Item.find_by_sql [ "select * from items where topic_id="+params[:id]+" order by updated_at desc" ]
  end

  def new
    @topic=Topic.new
  end

  def update
  end

  def create
    if signed_in? and current_user.is_admin then
      @topic=Topic.new(topic_params)

      @topic.created_by_id = current_user.id #current_user.id
      @topic.updated_by_id = current_user.id #current_user.id

      if @topic.save
        flash[:success] = "New topic added, id:"+@topic.id.to_s
        @edit=true

      #render edit panel to allow user to add links (can't do in create)
        @id=@topic.id
        params[:id]=@id.to_s
        show()
        render 'show'
      else
        flash[:error] = "Error creating topic"
        @edit=true
        render 'new'
      end
    else
      redirect_to '/'
    end

  end

  def destroy
  end

  private
  def topic_params
    params.require(:topic).permit(:name, :description, :owner_id, :is_owners, :is_public)
  end

end
