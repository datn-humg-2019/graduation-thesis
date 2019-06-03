class HistoriesController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!

  def index
    # @q = History.ransack(params[:q]) current_user.sales.ransack(params[:q]).result
    @histories = current_user.warehouse.all_histories.page(params[:page]).per(20)
  end

  def show
    @history_details = current_user.warehouse.detail_history params["date"]
  end
end
