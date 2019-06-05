class Api::UserApisController < Api::BaseController
  before_action :authenticate_request!

  def create_product_warehouse
    if params[:images].methods.include?(:each)
      product = Product.new product_params
      product.tag = ""
      product.description = ""

      if product.save
        params[:images].each do |img|
          product.images.create!(image: img)
        end
        save_pw product.id
        render_json "create succsess", current_user.warehouse.product_warehouses.find_by(product_id: product.id).load_attribute_product
      else
        render_json "errors #{product.errors.full_messages.to_sentence}", nil, 1
      end
    else
      render_json "Có lõi sảy ra", nil, 1
    end
  end

  private
  def product_params
    params.require(:product).permit :name, :category_id
  end

  def save_pw product_id
    pw = current_user.warehouse.product_warehouses.build
    pw.product_id = product_id
    pw.count = params[:count]
    pw.price_origin = params[:price_origin]
    pw.price_sale = params[:price_sale]
    pw.mfg = nil
    pw.exp = nil
    pw.stop_providing = false
    pw.save
    pw.save_history
  end
end
