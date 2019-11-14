# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'name validations' do
    before do
      @task = Task.new
    end

    context 'blank' do
      it 'can not be saved' do
        @task.name = ''
        expect(@task.save).to eq(false)
      end
    end

    context 'length over 50' do
      it 'can not be saved' do
        @task.name = 'a' * 51
        expect(@task.save).to eq(false)
      end
    end

    context 'length equals to 50' do
      it 'can be saved' do
        @task.name = 'a' * 50
        expect(@task.save).to eq(true)
      end
    end
  end

  describe 'status validations' do
    before do
      @task = Task.new
      @task.name = 'a' * 50
    end

    context 'invalid value' do
      it 'should raise argument error' do
        expect { @task.status = 4 }.to raise_error(ArgumentError)
      end
    end

    context 'valid value' do
      it 'can be saved' do
        @task.status = 1
        expect(@task.save).to eq(true)
      end
    end
  end
end
