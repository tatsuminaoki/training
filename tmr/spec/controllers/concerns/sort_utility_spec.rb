require 'rails_helper'

describe SortUtility do

  class TestController < ApplicationController
    include SortUtility
    def self.column_names
      ['aaa','bbb']
    end
  end

  describe TestController do
    describe '#sort_order' do
      it 'default is asc' do
        subject.params.merge!(order: '')
        expect(subject.sort_order).to eq 'asc'
      end

      it 'asc is asc' do
        subject.params.merge!(order: 'asc')
        expect(subject.sort_order).to eq 'asc'
      end

      it 'aSc is asc' do
        subject.params.merge!(order: 'aSc')
        expect(subject.sort_order).to eq 'asc'
      end

      it 'desc is desc' do
        subject.params.merge!(order: 'desc')
        expect(subject.sort_order).to eq 'desc'
      end

      it 'DeSc is desc' do
        subject.params.merge!(order: 'DeSc')
        expect(subject.sort_order).to eq 'desc'
      end

      it 'Something else is asc' do
        subject.params.merge!(order: 'Something')
        expect(subject.sort_order).to eq 'asc'
      end
    end

    describe '#sort_column' do
      it 'permitted' do
        subject.params.merge!(sort: 'aaa')
        expect(subject.sort_column(TestController)).to eq 'aaa'
      end

      it 'permitted column is not replaced with default' do
        subject.params.merge!(sort: 'bbb')
        expect(subject.sort_column(TestController, 'default')).to eq 'bbb'
      end

      it 'not permitted' do
        subject.params.merge!(sort: 'ccc')
        expect(subject.sort_column(TestController, 'default')).to eq 'default'
      end
    end
  end
end
