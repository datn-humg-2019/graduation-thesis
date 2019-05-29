class Api::ProductWarehousesController < Api::BaseController
  before_action :authenticate_request!
  before_action :check_admin?

  def inventory
    render_json "Lấy dữ liệu thành công", list_pws
  end

  private
  def list_pws
    total_count = 0
    total_price = 0
    list_products = []
    inventorys = ProductWarehouse.load_inventory
    inventorys.map do |p|
      total_count += p.total_count
      total_price += p.total_price
      list_products << {
        name: p.product.name,
        image: p.product.get_thumb_image.image.url,
        count: p.total_count,
        price: p.total_price
      }
    end
    {
      total_count: total_count,
      total_price: total_price,
      list_products: list_products
    }
  end
end
