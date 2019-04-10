class ProductsController < ApplicationController
  before_action :authenticate_user!

  def list_tag
    list_tag = Product.get_list_tag
    respond_to do |format|
      format.json{render json: {list_tag: list_tag}}
    end
  end
end
