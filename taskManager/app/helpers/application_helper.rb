module ApplicationHelper
  def sortable(column:, title: nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    css = (column == sort_column) ? "fa fa-sort-#{direction}" : "fa fa-sort"
    # TODO:CSSの切り替えも実施すること
    link_to title, {:sort => column, :direction => direction}, {:class => css}
  end

  def link_list
    result_active = controller.action_name == 'index'
    link_str = link_to I18n.t("actions.list"), list_index_path
    make_link_tag(result_active: result_active, link_str: link_str)
  end

  def link_new
    result_active = controller.action_name == "new" || controller.action_name == "create"
    link_str = link_to I18n.t("actions.new"), new_list_path
    make_link_tag(result_active: result_active, link_str: link_str)
  end

  def link_edit
    result_active = controller.action_name == "edit" || controller.action_name == "update"
    if result_active == true
      link_str = link_to I18n.t("actions.edit"), ''
      make_link_tag(result_active: result_active, link_str: link_str)
    end
  end

  private
  def make_link_tag(result_active: true, link_str: '')
    active_str = (result_active == true) ? 'active' : ''
    raw %(<li class='#{active_str}'>#{link_str}</li>)
  end
end
