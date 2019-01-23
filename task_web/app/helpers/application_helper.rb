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

  def link_edit_user
    active = (controller_name == 'registrations' && controller.action_name == 'edit')
    link_str = link_to I18n.t('links.edit_user'), edit_user_registration_path, class: 'nav-link'
    make_link_tag(active: active, link_str: link_str)
  end

  def devise_error_messages
    return '' if resource.errors.empty?
    html = ''
    # エラーメッセージ用のHTMLを生成
    resource.errors.full_messages.each do |msg|
      html += <<-EOF
        <div class="error_field alert alert-danger" role="alert">#{msg}</div>
      EOF
    end
    html.html_safe
  end

  private

  def make_link_tag(active: true, link_str: '')
    active_str = active ? 'active' : ''
    content_tag(:li, link_str, class: "nav-item #{active_str}")
  end
end
