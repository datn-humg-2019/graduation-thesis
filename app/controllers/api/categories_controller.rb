class Api::CategoriesController < Api::BaseController
  before_action :authenticate_request!
  before_action :check_admin?

  def index
    categories = Category.api_load_categories
    render_json "Lấy categories thành công", categories
  end

  def create
    category = Category.new
    category.name = params[:name]

    if category.save
      if params[:image]
        image = category.images.build
        image.image = params[:image]
        image.save
      end
      render_json "create success", Category.find(category.id).load_structure
    else
      render_json category.errors.messages, nil, 1
    end
  end
end
