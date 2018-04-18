require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  background do
    FactoryBot.create(:task, :due_date => '2018-05-01')
    FactoryBot.create(:task, :due_date => '2018-06-01')
    FactoryBot.create(:task, :due_date => '2018-05-15')
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
end
