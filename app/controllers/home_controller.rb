class HomeController < ApplicationController
  before_action :check_admin
  # authorize_resource :class => false
  before_action :authenticate_user!
  def index; end
 
  private

  def check_admin
    redirect_to admin_path if user_signed_in? && current_user.role == "admin"
  end
end
