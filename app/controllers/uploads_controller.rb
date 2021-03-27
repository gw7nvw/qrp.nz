class UploadsController < ApplicationController

  def new 
    @upload = Upload.new
    if !@contest=Contest.find(params[:contest_id]) then
      flash[:error]="Invalid contest"
      redirect_to '/'
    end
    
  end

  def create
    @upload = Upload.new(upload_params)

    success=@upload.save

    @contest_id=params[:contest_id]

    if success and @contest_id and @contest=Contest.find_by_id(@contest_id) then
      sheet=Roo::Spreadsheet.open(@upload.doc.path)
      @contest_log=ContestLog.import(sheet, @contest_id)
      @contest_log.post_notification
      redirect_to '/contest_logs/'+@contest_log.id.to_s 
    else
      flash[:error]="Error creating file"
      if !@contest=Contest.find_by_id(@contest_id) then
        flash[:error]="Invalid contest"
        redirect_to '/'
      end

      render 'new'
    end
    
  end
  private
  def upload_params
    params.require(:upload).permit(:doc)
  end
end
