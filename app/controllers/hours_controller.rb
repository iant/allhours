class HoursController < ApplicationController

  def index
    @hours = current_user.hours.all
    respond_to do |format|
      format.html
      format.json
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"hours.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end    


  end

  def create
    @hour = Hour.new(hour_params)

    @hour.user_id = current_user.id
    if @hour.save
      render json: @hour
    else
      render json: @hour.errors, status: :unprocessable_entity
    end
  end

  def update
    @hour = current_user.hours.find(params[:id])
    if @hour.update(hour_params)
      render json: @hour
    else
      render json: @hour.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @hour = current_user.hours.find(params[:id])    
    @hour.destroy
    head :no_content
  end

  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def hour_params
    params.require(:hour).permit(:user_id, :client, :project, :date, :hours)
  end


end
