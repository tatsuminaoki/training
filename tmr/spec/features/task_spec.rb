require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do

  before(:each) do
    user = FactoryBot.create(:task_user)

    visit login_path

    # Password is same as login_id
    fill_in 'login_id', with: user.login_id
    fill_in 'password', with: user.login_id
    click_on I18n.t('buttons.login')
  end

  describe 'トップページ' do
    it 'タスク一覧を表示' do
      visit root_path
      expect(page).to have_css('h1', text: I18n.t('titles.task.list'))
    end
  end

  describe '検索・ソート' do
    let!(:tasklist) {
      [
        FactoryBot.create(:task, title: 'title', description: 'タイ米', status: 1),
        FactoryBot.create(:task, title: 'taitoru', description: 'Titan', status: 2),
        FactoryBot.create(:task, title: 'タイトル', description: 'taipei', status: 3)
      ]
    }

    before(:each) do
      visit tasks_path
    end

    it 'すべてのタスク' do
      # "着手中"、"ステータス"
      click_on I18n.t('buttons.search')
      # すべてのレコードがある
      expect(page).to have_selector 'tbody tr td', text: I18n.t("models.statuses.values.v#{Status.find(1).id}")
      expect(page).to have_selector 'tbody tr td', text: I18n.t("models.statuses.values.v#{Status.find(2).id}")
      expect(page).to have_selector 'tbody tr td', text: I18n.t("models.statuses.values.v#{Status.find(3).id}")
      expect(page).to have_selector 'tbody tr td', text: 'title'
      expect(page).to have_selector 'tbody tr td', text: 'taitoru'
      expect(page).to have_selector 'tbody tr td', text: 'タイトル'
    end

    describe '検索' do
      describe 'ステータスで検索' do
        it '着手中のタスク' do
          # "着手中"、"ステータス"
          choose I18n.t("models.statuses.values.v#{Status.find(2).id}")
          click_on I18n.t('buttons.search')
          # "着手中" のみレコードがある
          expect(page).to have_selector 'tbody tr td', text: I18n.t("models.statuses.values.v#{Status.find(2).id}")
          expect(page).to_not have_selector 'tbody tr td', text: I18n.t("models.statuses.values.v#{Status.find(1).id}")
          expect(page).to_not have_selector 'tbody tr td', text: I18n.t("models.statuses.values.v#{Status.find(3).id}")
        end
      end

      describe 'キーワードで検索' do
        it '「タイ」を含むタスク' do
          fill_in I18n.t('labels.keyword'), with:  'タイ'
          click_on I18n.t('buttons.search')
          # 「タイ」を含むレコードのみがある
          expect(page).to have_selector 'tbody tr td', text: /タイトル|タイ米/
          expect(page).not_to have_selector 'tbody tr td', text: /Titan|taitoru/
        end
      end
    end

    describe 'ソート' do
      describe 'ステータスでソート' do
        it '降順' do
          click_on I18n.t('activerecord.attributes.task.status') + ' ▲'

          expect(all('tbody tr')[0].all('td')[3].text).to eq I18n.t("models.statuses.values.v#{Status.find(3).id}")
          expect(all('tbody tr')[all('tbody tr').length - 1].all('td')[3].text).to eq I18n.t("models.statuses.values.v#{Status.find(1).id}")
        end

        it '昇順' do
          # 2度押す
          click_on I18n.t('activerecord.attributes.task.status') + ' ▲'
          click_on I18n.t('activerecord.attributes.task.status') + ' ▼'

          expect(all('tbody tr')[0].all('td')[3].text).to eq I18n.t("models.statuses.values.v#{Status.find(1).id}")
          expect(all('tbody tr')[all('tbody tr').length - 1].all('td')[3].text).to eq I18n.t("models.statuses.values.v#{Status.find(3).id}")
        end
      end

      describe '検索＆ソート' do
        it '「タイ」を含むタスク' do
          fill_in I18n.t('labels.keyword'), with:  'タイ'
          click_on I18n.t('buttons.search')
          click_on I18n.t('activerecord.attributes.task.status') + ' ▲'
          # 「タイ」を含むレコードのみがある。ステータスでソートされている
          expect(page).to have_selector 'tbody tr td', text: /タイトル|タイ米/
          expect(page).not_to have_selector 'tbody tr td', text: /Titan|taitoru/
          expect(all('tbody tr')[0].all('td')[3].text).to eq I18n.t("models.statuses.values.v#{Status.find(3).id}")
          expect(all('tbody tr')[all('tbody tr').length - 1].all('td')[3].text).to eq I18n.t("models.statuses.values.v#{Status.find(1).id}")
        end
      end
    end
  end

  describe 'タスク詳細表示' do
    let!(:task) { FactoryBot.create(:task) }

    before(:each) do
      visit task_path(task.id)
    end

    it 'タスクページを表示' do
      expect(page).to have_css('h1', text: task.title)
      expect(page).to have_content task.title
      expect(page).to have_content task.description
    end

    describe '戻るリンク' do
      before do
        click_on I18n.t('buttons.back')
      end

      it '一覧ページに遷移' do
        expect(current_path).to eq tasks_path
      end
    end

    describe '編集リンク' do
      before do
        click_on I18n.t('buttons.edit')
      end

      it '編集ページに遷移' do
        expect(current_path).to eq edit_task_path(task.id)
      end
    end
  end


  describe 'タスク新規作成' do
    let!(:task) { FactoryBot.create(:task) }

    before(:each) do
      visit new_task_path
      fill_in I18n.t('activerecord.attributes.task.title'), with: 'title'
      fill_in I18n.t('activerecord.attributes.task.description'), with: 'desc'
    end

    it 'タスク作成ページを表示' do
      expect(page).to have_css('h1', text: I18n.t('titles.task.new'))
    end

    describe '正常' do
      before do
        click_on I18n.t('helpers.submit.create', model: I18n.t('activerecord.models.task'))
      end

      it 'タスク作成成功' do
        # Task
        expect(current_path).to eq task_path(Task.last.id)
        expect(page).to have_content Task.last.title
        expect(page).to have_content Task.last.description
        # Message
        expect(page).to have_content I18n.t('notices.created', model: I18n.t('activerecord.models.task'))
      end
    end

    describe '項目不足' do
      before do
        # with no title
        fill_in I18n.t('activerecord.attributes.task.title'), with: ''
        click_on I18n.t('helpers.submit.create', model: I18n.t('activerecord.models.task'))
      end

      it 'タスク作成失敗' do
        # Task
        expect(current_path).to eq tasks_path
        # Message
        expect(page).to have_content I18n.t('activerecord.errors.messages.blank')
      end
    end
  end


  describe 'タスク編集' do
    let!(:task) { FactoryBot.create(:task) }

    before(:each) do
      visit edit_task_path(task.id)
      fill_in I18n.t('activerecord.attributes.task.title'), with: 'modified title'
      fill_in I18n.t('activerecord.attributes.task.description'), with: 'modified desc'
    end

    it 'タスク編集ページを表示' do
      expect(page).to have_css('h1', text: I18n.t('titles.task.edit'))
    end

    describe '正常' do
      before do
        click_on I18n.t('helpers.submit.update', model: I18n.t('activerecord.models.task'))
      end

      it 'タスク編集成功' do
        # Task
        expect(current_path).to eq task_path(Task.last.id)
        expect(page).to have_content Task.last.title
        expect(page).to have_content Task.last.description
        # Message
        expect(page).to have_content I18n.t('notices.updated', model: I18n.t('activerecord.models.task'))
      end
    end

    describe '項目不足' do
      before do
        visit edit_task_path(task.id)
        # with no title
        fill_in I18n.t('activerecord.attributes.task.title'), with: ''
        click_on I18n.t('helpers.submit.update', model: I18n.t('activerecord.models.task'))
      end

      it 'タスク編集失敗' do
        # Task
        expect(current_path).to eq task_path(task.id)
        # Message
        expect(page).to have_content I18n.t('activerecord.errors.messages.blank')
      end
    end
  end

end
