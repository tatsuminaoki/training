# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:title) { 'title' }
  let(:status) { 0 }
  let(:description) { 'a' * 250 }
  subject { Task.new(title: title, description: description, status: status) }

  describe 'when valid' do
    context 'with valid attributes' do
      it { expect(subject).to be_valid }
    end

    context 'with a max-length title' do
      let(:title) { 'a' * 250 }
      it { expect(subject).to be_valid }
    end

    context 'with a valid status' do
      let(:status) { 2 }
      it { expect(subject).to be_valid }
    end
  end

  describe 'when not valid' do
    context 'without a title' do
      let(:title) { nil }
      it { expect(subject).not_to be_valid }
    end

    context 'without a status' do
      let(:status) { nil }
      it { expect(subject).not_to be_valid }

      let(:status) { 4 }
      it { expect(subject).not_to be_valid }
    end

    context 'with a title over max length' do
      let(:title) { 'a' * 251 }
      it { expect(subject).not_to be_valid }
    end
  end
end
