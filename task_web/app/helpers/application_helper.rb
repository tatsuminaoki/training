# frozen_string_literal: true

module ApplicationHelper
  def link_index_tasks
    active = controller.action_name == 'index'
    link_str = link_to I18n.t('links.index_tasks'), tasks_path, class: 'nav-link'
    make_link_tag(active: active, link_str: link_str)
  end

  def link_create_task
    active = controller.action_name == 'new'
    link_str = link_to I18n.t('links.create_task'), new_task_path, class: 'nav-link'
    make_link_tag(active: active, link_str: link_str)
  end

  private

  def make_link_tag(active: true, link_str: '')
    active_str = active ? 'active' : ''
    content_tag(:li, link_str, class: "nav-item #{active_str}")
  end
end
