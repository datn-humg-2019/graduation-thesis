module ApplicationHelper
  def convert_date date
    date&.strftime(t("date")) if date
  end

  def type_flash type
    return "success" if type == "notice"
    return "danger" if type == "alert"
    type
  end

  def slide_active name
    "active" if request.path == "/#{name}" || (request.path == "/dashboards" && name == "admin")
  end

  def working_label working
    status = "success"
    text = "Hoạt động"
    unless working
      status = "danger"
      text = "Inactivity"
    end
    "<span class='badge badge-#{status}'>#{text}</span>".html_safe
  end

  def role_label role
    case role
    when "admin"
      "<span class='badge badge-danger'>Admin</span>".html_safe
    when "vip"
      "<span class='badge badge-primary'>Bán buôn</span>".html_safe
    when "ctv"
      "<span class='badge badge-info'>CTV</span>".html_safe
    end
  end

  def stop_providing flag
    case flag
    when true
      "<h5><span class='badge badge-danger'>Ngừng cung cấp</span></h5>".html_safe
    when false
      "<h5><span class='badge badge-success'>Đang cung cấp</span></h5>".html_safe
    end
  end

  def gender_user gender
    return "<i class='fa fa-male'> Nam</i>".html_safe if gender
    return "<i class='fa fa-female'> Nu</i>".html_safe if gender == false
    "<i class='fa fa-adjust'> Khac</i>".html_safe
  end

  def to_currency number
    number_to_currency(number, unit: "VNĐ", separator: ",", delimiter: ".", format: "%n %u")
  end

  def today_to_string
    today = Date.current
    "Hà nội, Ngày #{today.day} tháng #{today.month} năm #{today.year}"
  end

  def stt_index page, per, index
    page.to_i.zero? ? index + 1 : (page.to_i - 1) * per.to_i + index + 1
  end

  def type_report
    [["Tháng", 1], ["Năm", 2]]
  end
end
