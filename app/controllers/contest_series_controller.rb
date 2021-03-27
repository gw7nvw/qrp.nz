class ContestSeriesController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :editgrid]

  def editgrid

  end

  def index_prep
    whereclause="true"
    if params[:filter] then
      @filter=params[:filter]
      whereclause="is_"+@filter+" is true"
    end

    @searchtext=params[:searchtext]
    if params[:searchtext] then
       whereclause=whereclause+" and lower(name) like '%%"+@searchtext.downcase+"%%'"
    end

    @contest_series=ContestSeries.find_by_sql [ 'select * from contest_series where '+whereclause+' order by name limit 100' ]
    counts=ContestSeries.find_by_sql [ 'select count(id) as id from contest_series where '+whereclause ]
    if counts and counts.first then @count=counts.first.id else @count=0 end
  end


  def index
    index_prep()
    respond_to do |format|
      format.html
      format.js
      format.csv { send_data contest_series_to_csv(@contest_series), filename: "contest_series-#{Date.today}.csv" }
    end
  end
  def show
    if(!(@contest_series = ContestSeries.find_by_id(params[:id].to_i)))
      redirect_to '/'
    end
  end

  def edit
    if params[:referring] then @referring=params[:referring] end

    if(!(@contest_series = ContestSeries.where(id: params[:id]).first))
      redirect_to '/'
    end
  end
  def new
    @contest_series = ContestSeries.new
    @contest_series.is_active=true
  end

 def create
    if signed_in? and current_user.is_modifier then

    @contest_series = ContestSeries.new(contest_series_params)
    @contest_series.createdBy_id=current_user.id

      if @contest_series.save
          @contest_series.reload
          if params[:referring]=='index' then
            index_prep()
            render 'index'
          else
            render 'show'
          end

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
      contest_series = ContestSeries.find_by_id(params[:id])
      if contest_series.contests and contest_series.contests.count>0 then
          flash[:error] = "ContestSeries contains contests. Cannot delete until contests have been deleted.  You could just set it to inactive to disable it but not delete."

          #tried to update a nonexistant hut
          render 'edit'
      else
        if contest_series and contest_series.destroy
          flash[:success] = "ContestSeries deleted, id:"+params[:id]
          index_prep()
          render 'index'
        else
          edit()
          render 'edit'
        end
      end
    else
      if(!@contest_series = ContestSeries.find_by_id(params[:id]))
          flash[:error] = "ContestSeries does not exist: "+@contest_series.id.to_s

          #tried to update a nonexistant hut
          render 'edit'
      end

      @contest_series.assign_attributes(contest_series_params)
      @contest_series.createdBy_id=current_user.id

      if @contest_series.save
        flash[:success] = "ContestSeries details updated"

        # Handle a successful update.
        if params[:referring]=='index' then
          index_prep()
          render 'index'
        else
          render 'show'
        end
      else
        render 'edit'
      end
    end
  else
    redirect_to '/'
  end
end

  def contest_series_params
    params.require(:contest_series).permit(:id, :name, :description, :start_date, :end_date, :include_valid, :include_qrp, :include_portable, :include_backcountry, :include_qth, :include_rst, :include_index, :include_freq, :members_only, :is_active, :base_points, :valid_points,  :qrp_points, :portable_points, :backcountry_points, :cw_points, :dx_points, :minreqs, :log_url, :xls_log_url, :odt_log_url, :score_per_hour)
  end

end
