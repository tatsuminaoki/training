require 'rails_helper'

RSpec.describe Search, type: :model do
  describe 'Method Search' do
    context 'Data of project and task is exists' do
      let(:project) { create(:project, :with_group, name: 'TEST1') }
      context 'query is matching with data' do
        it 'is get project and task' do
          create(:task, group: project.groups.first, name: 'TEST1')
          projects_list, tasks_List = Search.find_by_name('TEST1')
          expect(projects_list.count).to eq 1
          expect(tasks_List.count).to eq 1
        end
      end

      context 'query is not matching with data' do
        it 'could not get project and task' do
          create(:task, group: project.groups.first, name: 'TEST1')
          projects_list, tasks_List = Search.find_by_name('TEST2')
          expect(projects_list.count).to eq 0
          expect(tasks_List.count).to eq 0
        end
      end
    end

    context 'Just data of project is exists' do
      it 'is get project' do
        create(:project, :with_group, name: 'TEST1')
        projects_list, tasks_List = Search.find_by_name('TEST1')
        expect(projects_list.count).to eq 1
        expect(tasks_List.count).to eq 0
      end
    end

    context 'Just matching data is task' do
      let(:project) { create(:project, :with_group, name: 'TEST2') }
      it 'is get task' do
        create(:task, group: project.groups.first, name: 'TEST1')
        projects_list, tasks_List = Search.find_by_name('TEST1')
        expect(projects_list.count).to eq 0
        expect(tasks_List.count).to eq 1
      end
    end

    context 'both data of project and task is not exists' do
      it 'could not get both data ' do
        projects_list, tasks_List = Search.find_by_name('TEST1')
        expect(projects_list.count).to eq 0
        expect(tasks_List.count).to eq 0
      end
    end
  end
end
