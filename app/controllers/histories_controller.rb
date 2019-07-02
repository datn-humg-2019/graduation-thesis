class HistoriesController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!

  def index
    @histories = current_user.warehouse.all_histories.page(params[:page]).per(10)
  end

  def show
    @details = current_user.warehouse.detail_history(params["date"])
    @history_details = @details.page(params[:page]).per(20)
  end
end
