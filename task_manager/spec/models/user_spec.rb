# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

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
  end
end
