class HomeController < ApplicationController
  before_action :check_admin
  # authorize_resource :class => false
  before_action :authenticate_user!
  def index; end
end
