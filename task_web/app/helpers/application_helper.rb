# frozen_string_literal: true

module ApplicationHelper
  def action_names
    if controller.action_name == 'new'
      { action: :create, action_name: 'actions.create' }
    else
      { action: :update, action_name: 'actions.update' }
    end
  end

  def link_index_tasks
    active = (controller_name == 'tasks' && controller.action_name == 'index')
    link_str = link_to I18n.t('links.index_tasks'), tasks_path, class: 'nav-link'
    make_link_tag(active: active, link_str: link_str)
  end

  def link_create_task
    p controller_name
    p controller.action_name
    active = (controller_name == 'tasks' && controller.action_name == 'new')
    link_str = link_to I18n.t('links.create_task'), new_task_path, class: 'nav-link'
    make_link_tag(active: active, link_str: link_str)
  end

  def link_edit_user
    active = (controller_name == 'registrations' && controller.action_name == 'edit')
    link_str = link_to I18n.t('links.edit_user'), edit_user_registration_path, class: 'nav-link'
    make_link_tag(active: active, link_str: link_str)
  end

  def link_index_users_admin
    active = (controller_name == 'users' && controller.action_name == 'index')
    link_str = link_to I18n.t('links.index_users_admin'), admin_users_path, class: 'nav-link'
    make_link_tag(active: active, link_str: link_str)
  end

  def link_create_user_admin
    p controller_name
    p controller.action_name
    active = controller.action_name == 'admin/users/new'
    link_str = link_to I18n.t('links.create_user_admin'), new_admin_user_path, class: 'nav-link'
    make_link_tag(active: active, link_str: link_str)
  end

  private

  def make_link_tag(active: true, link_str: '')
    active_str = active ? 'active' : ''
    content_tag(:li, link_str, class: "nav-item #{active_str}")
  end
end
