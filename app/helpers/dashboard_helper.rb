module DashboardHelper
  def gender_selected
    [["Nữ", false], ["Nam", true], ["Khác", nil]]
  end

  def role_selected
    [["ADMIN", "admin"], ["VIP", "vip"], ["CTV", "ctv"]]
  end

  def category_selected
    Category.pluck :name, :id
  end
end
