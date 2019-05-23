# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  describe 'name varidates' do
    context 'with nil' do
      it 'could not save' do
        user.name = nil
        expect(user.save).to be_falsey
      end
    end
    context 'with not nil' do
      it 'could save' do
        user.name = 'name'
        expect(user.save).to be_truthy
      end
    end
    context 'with not uniqueness name' do
      it 'could not save' do
        user.name = 'same name'
        expect(user.save).to be_truthy
        other_user.name = 'same name'
        expect(other_user.save).to be_falsey
      end
    end
    context 'with uniqueness name' do
      it 'could save' do
        user.name = 'name'
        expect(user.save).to be_truthy
        other_user.name = 'other name'
        expect(other_user.save).to be_truthy
      end
    end
  end

  describe 'role varidates' do
    context 'with nil' do
      it 'could not save' do
        user.role = nil
        expect(user.save).to be_falsey
      end
    end
    context 'with not nil' do
      it 'could save' do
        user.role = 0
        expect(user.save).to be_truthy
      end
    end
    context 'with out of range number' do
      it 'could not save' do
        user.role = 2
        expect(user.save).to be_falsey
      end
    end
  end

  describe 'password varidates' do
    context 'with nil' do
      it 'could not save' do
        user.password = nil
        expect(user.save).to be_falsey
      end
    end
    context 'with not nil' do
      it 'could save' do
        user.password = 'password'
        expect(user.save).to be_truthy
      end
    end
    context 'with too short string' do
      it 'could not save' do
        user.password = ('a' * 5).to_s
        expect(user.save).to be_falsey
      end
    end
    context 'with string of appropriate length' do
      it 'could save' do
        user.password = ('a' * 6).to_s
        expect(user.save).to be_truthy
      end
    end
  end
end
