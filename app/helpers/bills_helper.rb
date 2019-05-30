module BillsHelper
  def for_user_ctv
    list_user = []
    User.ctv_user.map{|u| list_user << ["#{u.get_user_code} | #{u.name}", u.id]}
    list_user
  end

  def form_user_vip form_user_id
    list_user = []
    if form_user_id.nil?
      User.vip_user.map{|u| list_user << ["#{u.get_user_code} | #{u.name}", u.id]}
    else
      User.vip_user.map{|u| list_user << ["#{u.get_user_code} | #{u.name}", u.id] if u.id == form_user_id}
    end
    list_user
  end

  def get_user_filter
    User.where(id: current_user.sales.pluck(:to_user_id).uniq).pluck :name, :id
  end

  def status_confirmed confirmed
    case confirmed
    when true
      "<h5><span class='badge badge-success'>Đã giải quyết</span></h5>".html_safe
    else
      "<h5><span class='badge badge-danger'>Đang chờ giải quyết</span></h5>".html_safe
    end
  end
end
