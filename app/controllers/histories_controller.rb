class HistoriesController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!

  def index
    params[:to_date] = convert_date params[:to_date] if params[:to_date].present?
    params[:to_date] = convert_date params[:to_date] if params[:to_date].present?
    @histories = current_user.warehouse.all_histories_search_date(params[:from_date], params[:to_date]).page(params[:page]).per(10)
  end

  def show
    @details = current_user.warehouse.detail_history(params["date"])
    @history_details = @details.page(params[:page]).per(20)
  end
end
