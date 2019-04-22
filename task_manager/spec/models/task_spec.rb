# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { create(:task) }

  describe 'name varidates' do
    context 'with nil' do
      it 'could not save' do
        task.name = nil
        expect(task.save).to be_falsey
      end
    end
    context 'with not nil' do
      it 'could save' do
        task.name = 'name'
        expect(task.save).to be_truthy
      end
    end
    context 'with too long string' do
      it 'could not save' do
        task.name = ('a' * 65).to_s
        expect(task.save).to be_falsey
      end
    end
  end
end
