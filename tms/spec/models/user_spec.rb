require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:user)).to be_valid
    end

    it 'is invalid without name' do
      user = FactoryBot.build(:user, name: nil)
      expect(user).to be_invalid
    end

    it 'is invalid with a duplicate name' do
      user = FactoryBot.create(:user, name: 'test_user1')
      new_user = FactoryBot.build(:user, name: 'test_user1')
      expect(new_user).to be_invalid
    end

    it 'is invalid without password' do
      user = FactoryBot.build(:user, password: nil)
      expect(user).to be_invalid
    end

    it 'is invalid with less than 6 characters as password' do
      user = FactoryBot.build(:user, password: 'pswd')
      expect(user).to be_invalid
    end
  end
end
