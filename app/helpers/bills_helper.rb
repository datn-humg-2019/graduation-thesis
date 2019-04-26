module BillsHelper
  def for_user_ctv
    list_user = []
    User.ctv_user.map{|u| list_user << ["#{u.get_user_code} | #{u.name}", u.id]}
    list_user
  end
end
