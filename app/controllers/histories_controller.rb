class HistoriesController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!

  def index
    @histories = current_user.warehouse.all_histories.page(params[:page]).per(10)
  end

  def show
    @history_details = current_user.warehouse.detail_history params["date"]
  end
end
