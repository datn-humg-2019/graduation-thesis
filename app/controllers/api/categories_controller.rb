class Api::CategoriesController < Api::BaseController
  before_action :authenticate_request!
  before_action :check_admin?

  def index
    categories = Category.api_load_categories
    render_json categories, "succsess"
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
      render_json Category.find(category.id).load_structure, "create success"
    else
      render_json nil, category.errors.messages, true
    end
  end

  def destroy

  end
end
