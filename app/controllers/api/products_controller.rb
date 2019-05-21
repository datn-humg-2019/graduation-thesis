class Api::ProductsController < Api::BaseController
  before_action :authenticate_request!
  before_action :check_admin?

  def index
    products = Product.api_load_products
    render_json products, "succsess"
  end

  def create
    product = Product.new product_params
    if product.save
      params[:images].each do |img|
        product.images.create!(image: img)
      end
      render_json Product.find(product.id).load_structure, "create succsess"
    else
      render_json nil, "errors #{product.errors.full_messages.to_sentence}"
    end
  end

  private
  def product_params
    params.require(:product).permit :name, :tag, :description, :category_id
  end
end
