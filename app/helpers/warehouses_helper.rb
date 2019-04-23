module WarehousesHelper
  def category_list
    Category.pluck :name, :id
  end
end
