class WarehousesController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!

  def index
    @warehouse = current_user.warehouse
  end
end
