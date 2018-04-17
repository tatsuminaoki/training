require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'Valid task' do
    task = Task.new(
      title: 'Valid Title',
      description: 'Valid Description',
      status: 0,
      priority: 0,
      due_date: Time.now + 1.day
    )
    expect(task).to be_valid
  end
  it 'Invalid title' do
    task = Task.new(
      title: nil,
      description: 'Valid Description',
      status: 0,
      priority: 0,
      due_date: Time.now + 1.day
    )
    expect(task).to_not be_valid
    expect(task.errors[:title]).to be_present
  end
  it 'Invalid status' do
    task = Task.new(
      title: 'Valid Title',
      description: 'Valid Description',
      status: 3,
      priority: 0,
      due_date: Time.now + 1.day
    )
    expect(task).to_not be_valid
    expect(task.errors[:status]).to be_present
  end
  it 'Invalid priority' do
    task = Task.new(
      title: 'Valid Title',
      description: 'Valid Description',
      status: 0,
      priority: 3,
      due_date: Time.now + 1.day
    )
    expect(task).to_not be_valid
    expect(task.errors[:priority]).to be_present
  end
end
