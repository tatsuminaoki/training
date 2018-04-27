require 'rails_helper'

RSpec.describe Label, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:label)).to be_valid
  end

  it 'is invalid without name' do
    label = FactoryBot.build(:label, name: nil)
    expect(label).to be_invalid
  end

  it 'is invalid with a duplicate name' do
    label = FactoryBot.create(:label, name: 'label1')
    new_label = FactoryBot.build(:label, name: 'label1')
    expect(new_label).to be_invalid
  end

  it 'is valid with less than 10 characters as name' do
    label = FactoryBot.build(:label, name: '1234567890')
    expect(label).to be_valid
  end

  it 'is invalid with more than 10 characters as name' do
    label = FactoryBot.build(:label, name: '12345678901')
    expect(label).to be_invalid
  end
end
