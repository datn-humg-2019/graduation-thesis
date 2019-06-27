class Api::SellsController < Api::BaseController
  before_action :authenticate_request!
  before_action :not_admin?

  def index
    sells = current_user.sells.map(&:load_structure)
    render_json "Lấy dữ liệu thành công", sells
  end

  def sell_product
    if params[:product_ids].blank? || params[:counts].blank? || params[:email].blank?
      render_json "Dữ liệu ko hợp lệ", nil, 1
    else
      p_ids = params[:product_ids].split(",").map{|p| p.strip.to_i}
      counts = params[:counts].split(",").map{|p| p.strip.to_i}

      if p_ids.size != counts.size
        render_json "Dữ liệu ko hợp lệ", nil, 1
        return
      end

      sell = current_user.sells.build
      sell.sell_code = "BH"
      sell.description = "Bán hàng cho khách vãng lai"
      sell.total_count = 0
      sell.total_price = 0

      if sell.save
        details sell, p_ids, counts
        SellBillMailer.sell_bill(sell, params[:email]).deliver_now unless params[:email].blank?
        render_json "Bán hàng thành công", sell.load_structure, 1
      else
        render_json "Thất bại: #{sell.errors.messages}", nil, 1
      end
    end
  end

  def sell_detail
    if params[:sell_id].blank?
      render_json "Dữ liệu ko hợp lệ", nil, 1
    else
      sell = current_user.sells.find_by(id: params[:sell_id])
      if sell.nil?
        render_json "Hóa đơn Bán không tồn tại", nil, 1
      else
        render_json "Lấy dữ liệu thành công", sell.load_structure
      end
    end
  end

  private
  def details sell, p_ids, counts
    pws = current_user.warehouse.product_warehouses.where(product_id: p_ids)
    pws.each_with_index do |pw, i|
      next if counts[i].to_i == 0
      detail = sell.details.build
      detail.product_warehouse_id = pw.id
      detail.count = counts[i]
      detail.price = pw.price_sale
      detail.save
    end
    sell.update_product_in_warehouse
    sell.auto_update_attribute
  end
end
