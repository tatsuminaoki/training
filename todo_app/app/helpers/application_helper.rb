module ApplicationHelper
  def hyphen_if_blank(value)
    value.blank? ? '-' : value
  end
end
