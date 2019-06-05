class Api::WarehousesController < Api::BaseController
  before_action :authenticate_request!

  def index
    if current_user.admin?
      render_json "Bạn không có quyền thực hiện công việc này", nil, 1
    else
      products = Product.by_category(params[:category_id])
                        .by_name(params[:name])
                        .by_id(params[:product_id])
                        .pluck :id

      warehouse = current_user.warehouse.product_warehouses
                              .where(product_id: products)
                              .map{|x| x.load_attribute_product}
      render_json "Lấy dữ liệu thành công", warehouse
    end
  end

  def list_categories
    if current_user.admin?
      render_json "Bạn không có quyền thực hiện công việc này", nil, 1
    else
      ids = current_user.warehouse.product_warehouses
                        .map{|pw| pw.product.category.id}.uniq

      categories = Category.where(id: ids).map{|c| c.load_structure }
      render_json "Lấy dữ liệu thành công", categories
    end
  end

  def user_inventory
    if current_user.admin?
      render_json "Bạn không có quyền thực hiện công việc này", nil, 1
    else
      render_json "Lấy dữ liệu thành công", list_pws
    end
  end

  def user_stop_providing
    if current_user.admin?
      render_json "Bạn không có quyền thực hiện công việc này", nil, 1
    else
      current_user.warehouse.stop_providing_product params["product_id"]
      render_json "Sản phẩm đã được dừng cung cấp"
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
