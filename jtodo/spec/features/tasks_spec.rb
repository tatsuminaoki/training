require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  let!(:user) { create(:user) }

  background do
    login_as(user)
    FactoryBot.create(:task, title: 'test1', description: 'test3', status:0, priority:1, due_date: '2018-05-01')
    FactoryBot.create(:task, title: 'test2', description: 'test1', status:1, priority:2, due_date: '2018-06-01')
    FactoryBot.create(:task, title: 'test3', description: 'test2', status:1, priority:0, due_date: '2018-05-15')
  end

  scenario 'タスク一覧がちゃんと表示されている' do
    visit 'tasks'
    expect(page).to have_content 'タスク一覧'
  end

  scenario 'タスク作成が出来る' do
    visit 'tasks'

    click_link 'new_task'

    fill_in 'task_title', with: 'test0'
    fill_in 'task_description', with: 'testdesc'
    select '高い', from: 'task_priority'
    select 'やってる', from: 'task_status'
    
    submit_form

    expect(page).to have_content 'test0'
    expect(page).to have_content 'testdesc'
    expect(page).to have_content '高い'
    expect(page).to have_content 'やってる'

    click_on '戻る'

    expect(page).to have_content 'test0'
  end

  scenario 'タスク修正がちゃんと出来る' do
  end

  scenario 'タスク削除がちゃんと出来る' do
  end

  scenario '終了期限のソートがちゃんと機能している' do
    visit 'tasks'

    click_link 'sort_due_date'
    expect(page).to have_no_link('▼', href: '/tasks?sort=due_date+desc')
    expect(page).to have_link('▲', href: '/tasks?sort=due_date')
    expect(find('tbody').first('tr')).to have_text('2018/06/01')

    click_link 'sort_due_date'
    expect(page).to have_link('▼', href: '/tasks?sort=due_date+desc')
    expect(page).to have_no_link('▲', href: '/tasks?sort=due_date')
    expect(find('tbody').first('tr')).to have_text('2018/05/01')
  end

  scenario '優先度のソートがちゃんと機能している' do
    visit 'tasks'

    click_link 'sort_priority'
    expect(page).to have_no_link('▼', href: '/tasks?sort=priority+desc')
    expect(page).to have_link('▲', href: '/tasks?sort=priority')
    expect(find('tbody').first('tr')).to have_text('高い')

    click_link 'sort_priority'
    expect(page).to have_link('▼', href: '/tasks?sort=priority+desc')
    expect(page).to have_no_link('▲', href: '/tasks?sort=priority')
    expect(find('tbody').first('tr')).to have_text('低い')
  end

  scenario '検索がちゃんと機能している' do
    visit 'tasks'
    fill_in 'search', with: 'test1'
    click_on '検索'

    expect(page).to have_content 'test1' # 'test1' from title
    expect(page).to have_content 'test2' # 'test1' from description
    expect(page).to_not have_content 'test3'

    select 'やってる', from: 'status'
    click_on '検索'

    expect(page).to_not have_content 'test1'
    expect(page).to have_content 'test2' # 'test1' from description and status is 1(working)
    expect(page).to_not have_content 'test3'
  end
end
