# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'name validations' do
    let(:task) { build(:task, name: name) }
    subject { task.save }

    context 'blank' do
      let(:name) { '' }
      it 'can not be saved' do
        is_expected.to be_falsy
      end
    end

    context 'length over 50' do
      let(:name) { 'a' * 51 }
      it 'can not be saved' do
        is_expected.to be_falsy
      end
    end

    context 'length equals to 50' do
      let(:name) { 'a' * 50 }
      it 'can be saved' do
        is_expected.to be_truthy
      end
    end
  end

  describe 'status validations' do
    let(:task) { build(:task, name: 'a' * 50, status: status) }

    context 'invalid value' do
      let(:status) { 4 }
      it 'should raise argument error' do
        expect { task }.to raise_error(ArgumentError)
      end
    end

    context 'valid value' do
      let(:status) { 1 }
      it 'can be saved' do
        expect(task.save).to be_truthy
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
      5.times do
        create(:task)
      end
    end

    context 'when first page' do
      let(:page) { 1 }
      let(:per_page) { 2 }

      it 'return only 2 tasks' do
        is_expected.to eq(per_page)
      end
    end

    context 'when middle page' do
      let(:page) { 2 }
      let(:per_page) { 2 }

      it 'return only 2 tasks' do
        is_expected.to eq(per_page)
      end
    end

    context 'when last page' do
      let(:page) { 3 }
      let(:per_page) { 1 }

      it 'return only 1 tasks' do
        is_expected.to eq(per_page)
      end
    end

    context 'when page not exists' do
      let(:page) { 4 }
      let(:per_page) { 0 }

      it 'return no results' do
        is_expected.to eq(per_page)
      end
    end
  end
end
