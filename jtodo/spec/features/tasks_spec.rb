require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  background do
    FactoryBot.create(:task, title: 'test1', description: 'test3', due_date: '2018-05-01')
    FactoryBot.create(:task, title: 'test2', description: 'test1', status:1, due_date: '2018-06-01')
    FactoryBot.create(:task, title: 'test3', description: 'test2', status:1,  due_date: '2018-05-15')
  end
  scenario 'ソートリンクがちゃんと機能している' do
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
