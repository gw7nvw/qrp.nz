class HotaController < ApplicationController
def delete
 if signed_in?  then
    @post=HotaPost.find_by_id(params[:id])
    if @post and (current_user.is_admin or (current_user.id==@post.created_by_id)) then
      @item=@post.item
      @item.destroy

      if @post.destroy
        flash[:success] = "Post deleted, id:"+params[:id]

      else
        flash[:error] = "Failed to delete post"
      end
    else
      flash[:error] = "Failed to delete post"
    end
  else
    flash[:error] = "Failed to delete post"
  end
  redirect_to '/'
end

end
