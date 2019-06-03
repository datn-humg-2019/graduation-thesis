class Api::WarehousesController < Api::BaseController
  before_action :authenticate_request!

  def index
    products = Product.by_category(params[:category_id])
                      .by_name(params[:name])
                      .by_id(params[:product_id])
                      .pluck :id

    warehouse = current_user.warehouse.product_warehouses
                            .where(product_id: products)
                            .map{|x| x.load_attribute_product}
    render_json "Lấy dữ liệu thành công", warehouse
  end

  def list_categories
    ids = current_user.warehouse.product_warehouses
                      .map{|pw| pw.product.category.id}.uniq

    categories = Category.where(id: ids).map{|c| c.load_structure }
    render_json "Lấy dữ liệu thành công", categories
  end
end
