class ContestsController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :editgrid]

  def editgrid

  end

  def upload

  end
  def show
    if params[:referring] then @referring=params[:referring] end
    if(!(@contest = Contest.where(id: params[:id]).first))
      redirect_to '/'
    end

  end
 def edit
    if params[:referring] then @referring=params[:referring] end

    if(!(@contest = Contest.where(id: params[:id]).first))
      redirect_to '/'
    end
  end
  def new
    @contest = Contest.new
    @contest.is_active=true
    @contest.contest_series_id=params[:series_id]
  end

 def create
    if signed_in? and current_user.is_modifier then

    @contest = Contest.new(contest_params)
    @contest.createdBy_id=current_user.id

      if @contest.save
          @contest.reload
          redirect_to '/contest_series/'+@contest.contest_series_id.to_s

      else
          render 'new'
      end
    else
      redirect_to '/'
    end
 end

def update
  if signed_in? and current_user.is_modifier then
    if params[:delete] then
      contest = Contest.find_by_id(params[:id])
      contest_series_id=contest.contest_series_id
      if contest.contacts and contest.contacts.count>0 then
          flash[:error] = "Contest contains contacts. Cannot delete until contacts have been deleted.  You could just set it to inactive to disable it but not delete."

          #tried to update a nonexistant hut
          render 'edit'
      else
        if contest and contest.destroy
          flash[:success] = "Contest deleted, id:"+params[:id]
          redirect_to '/contest_series/'+contest_series_id.to_s

        else
          edit()
          render 'edit'
        end
      end
    else
      if(!@contest = Contest.find_by_id(params[:id]))
          flash[:error] = "Contest does not exist: "+@contest.id.to_s

          #tried to update a nonexistant hut
          render 'edit'
      end

      @contest.assign_attributes(contest_params)
      @contest.createdBy_id=current_user.id
      if @contest.save
        flash[:success] = "Contest details updated"

        # Handle a successful update.
        redirect_to '/contest_series/'+@contest.contest_series_id.to_s
      else
        render 'edit'
      end
    end
  else
    redirect_to '/'
  end
end

  def contest_params
    params.require(:contest).permit(:id, :contest_series_id, :name, :description, :start_time, :end_time, :is_active, :shortname)
  end

end
