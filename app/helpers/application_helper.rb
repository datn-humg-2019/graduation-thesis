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
    "active" if controller_name == name
  end

  def working_label working
    status = "success"
    text = "Working"
    unless working
      status = "danger"
      text = "Inactivity"
    end
    "<span class='label label-#{status}'>#{text}</span>".html_safe
  end

  def role_label role
    case role
    when "admin"
      "<span class='label bg-red'>Admin</span>".html_safe
    when "manage"
      "<span class='label bg-orange'>Mange</span>".html_safe
    when "teacher"
      "<span class='label bg-blue'>Teacher</span>".html_safe
    when "student_parent"
      "<span class='label bg-yellow'>Parent</span>".html_safe
    end
  end

  def gender_user gender
    return "<i class='fa fa-male'> Nam</i>".html_safe if gender
    return "<i class='fa fa-female'> Nu</i>".html_safe if gender == false
    "<i class='fa fa-adjust'> Khac</i>".html_safe
  end
end
