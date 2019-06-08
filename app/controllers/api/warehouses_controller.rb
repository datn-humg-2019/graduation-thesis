class Api::WarehousesController < Api::BaseController
  before_action :authenticate_request!
  before_action :not_admin?

  def index
    products = Product.by_category(params[:category_id])
                      .by_name(params[:name])
                      .by_id(params[:product_id])
                      .ids

    warehouse = current_user.warehouse.product_warehouses
                            .where(product_id: products)
                            .map{|x| x.load_attribute_product}
    render_json "Lấy dữ liệu thành công", warehouse
  end

  def list_categories
    ids = current_user.warehouse.product_warehouses.map{|pw| pw.product.category.id}.uniq
    ids_start = current_user.warehouse.product_warehouses.where(stop_providing: false).map{|pw| pw.product.category.id}.uniq

    categories = Category.where(id: ids).map{|c| c.load_structure(ids_start.include?(c.id) ? false : true)}
    render_json "Lấy dữ liệu thành công", categories
  end

  def user_inventory
    render_json "Lấy dữ liệu thành công", list_pws
  end

  def user_stop_providing
    if params["product_id"].blank?
      render_json "Dữ liệu ko hợp lệ", nil, 1
    else
      current_user.warehouse.stop_providing_product params["product_id"].to_i, true
      render_json "Sản phẩm đã được dừng cung cấp"
    end
  end

  def user_stop_providing_category
    if params["category_id"].blank?
      render_json "Dữ liệu ko hợp lệ", nil, 1
    else
      current_user.warehouse.stop_providing_category params["category_id"].to_i, true
      render_json "Nhóm sản phẩm đã được dừng cung cấp"
    end
  end

  def user_start_providing
    if params["product_id"].blank?
      render_json "Dữ liệu ko hợp lệ", nil, 1
    else
      current_user.warehouse.stop_providing_product params["product_id"].to_i, false
      render_json "Sản phẩm đã được cung cấp lại"
    end
  end

  def user_start_providing_category
    if params["category_id"].blank?
      render_json "Dữ liệu ko hợp lệ", nil, 1
    else
      current_user.warehouse.stop_providing_category params["category_id"].to_i, false
      render_json "Nhóm sản phẩm đã được cung cấp lại"
    end
  end

  private
  def list_pws
    warehouse = current_user.warehouse
    list_products = []
    warehouse.product_inventory.map do |pw|
      list_products << {
        name: pw.product.name,
        image: pw.product.get_thumb_image.image.url,
        count: pw.count,
        price: pw.price_origin
      }
    end
    {
      total_count: warehouse.sum_count,
      total_price: warehouse.sum_price_origin,
      list_products: list_products
    }
  end
end
