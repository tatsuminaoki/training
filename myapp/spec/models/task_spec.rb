# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'name validations' do
    let(:task) { create(:user_with_tasks, name: 'name').tasks.first }
    subject { task.save }

    context 'blank' do
      it 'can not be saved' do
        task.name = ''
        is_expected.to eq(false)
      end
    end

    context 'length over 50' do
      it 'can not be saved' do
        task.name = 'a' * 51
        is_expected.to eq(false)
      end
    end

    context 'length equals to 50' do
      it 'can be saved' do
        task.name = 'a' * 50
        is_expected.to eq(true)
      end
    end
  end

  describe 'status validations' do
    let(:task) { create(:user_with_tasks, name: 'name').tasks.first }

    context 'invalid value' do
      it 'should raise argument error' do
        expect { task.status = 4 }.to raise_error(ArgumentError)
      end
    end

    context 'valid value' do
      it 'can be saved' do
        task.status = 1
        expect(task.save).to eq(true)
      end
    end
  end

  describe '#page' do
    let(:tasks) {
      Task.name_like(params[:name])
      .status_is(params[:status])
      .sort_by_column(params[:sort_column], params[:order])
      .page params[:page]
    }
    let(:params) { { page: page } }
    subject { tasks.length }

    before do
      create(:user_with_tasks, tasks_count: 5)
    end

    context 'when first page' do
      let(:page) { 1 }

      it 'return only 2 tasks' do
        is_expected.to eq(2)
      end
    end

    context 'when middle page' do
      let(:page) { 2 }

      it 'return only 2 tasks' do
        is_expected.to eq(2)
      end
    end

    context 'when last page' do
      let(:page) { 3 }

      it 'return only 1 tasks' do
        is_expected.to eq(1)
      end
    end

    context 'when page not exists' do
      let(:page) { 4 }

      it 'return no results' do
        is_expected.to eq(0)
      end
    end
  end
end
