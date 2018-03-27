# frozen_string_literal: true

module TestHelpers
  def login(user: create(:user))
    visit login_path
    fill_in I18n.t('page.login.labels.user_name'), with: user.name
    fill_in I18n.t('page.login.labels.password'), with: user.password
    click_on I18n.t('page.common.login')
  end

  def visit_after_login(user: nil, visit_path: nil)
    login(user: user)
    visit visit_path unless visit_path
  end

  def visit_without_login(visit_path: nil)
    logout
    visit visit_path unless visit_path
  end

  def logout
    find('i.fa-user-circle').click
    find('a[href="/logout"]').click
  end

  def fill_in_datetime_select(date, id_prefix)
    select date.strftime('%Y'), from: "#{id_prefix}_1i"
    select date.strftime('%-m月'), from: "#{id_prefix}_2i"
    select date.strftime('%-d'), from: "#{id_prefix}_3i"
    select date.strftime('%H'), from: "#{id_prefix}_4i"
    select date.strftime('%M'), from: "#{id_prefix}_5i"
  end

  def click_sort_pulldown(sort_type)
    find(:css, '.fa-search').click
    within('#search_modal .modal-body') { select Task.human_attribute_name("sort_kinds.#{sort_type}"), from: 'search_sort' }
    click_on I18n.t('helpers.submit.search')
  end

  def title_search(title)
    find(:css, '.fa-search').click
    within('#search_modal .modal-body') { fill_in I18n.t('page.task.labels.title'), with: title }
    click_on I18n.t('helpers.submit.search')
  end

  def add_label(id, labels)
    labels.each do |label|
      page.execute_script("$('#{id}').tagit('createTag', '#{label}')")
    end
  end

  def delete_label(id, labels)
    labels.each do |label|
      page.execute_script("$('#{id}').tagit('removeTagByLabel', '#{label}')")
    end
  end
end
