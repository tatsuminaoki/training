require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'Valid task' do
    task = build(:task)
    expect(task).to be_valid
  end
  it 'Invalid title' do
    task = build(:task, title: nil)
    expect(task).to be_invalid
    expect(task.errors[:title]).to be_present
  end
  it 'Invalid status' do
    task = build(:task, status: nil)
    expect(task).to be_invalid
    expect(task.errors[:status]).to be_present
  end
  it 'Invalid priority' do
    task = build(:task, priority: nil)
    expect(task).to be_invalid
    expect(task.errors[:priority]).to be_present
  end
  it 'Search could find a task from title' do
    create(:task, title: 'Rspec Search Test')
    @search_result = Task.search('Rspec')
    expect(@search_result).to exist
    expect(@search_result[0].title).to eq('Rspec Search Test')
  end
  it 'Search could find a task from description' do
    create(:task, description: 'Rspec Search Test')
    @search_result = Task.search('Rspec')
    expect(@search_result).to exist
    expect(@search_result[0].description).to eq('Rspec Search Test')
  end
end
