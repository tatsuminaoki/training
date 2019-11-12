require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'with invalid values' do
    it 'blank name' do
      task = Task.new
      expect(task.save).to eq(false)
    end

    it 'name too long' do
      task = Task.new
      task.name = 'a' * 51
      expect(task.save).to eq(false)
    end

    it 'status' do
      task = Task.new
      task.name = 'a' * 50
      # expect() seems doesn't work for this
      expect {task.status = 4}.to raise_error(ArgumentError)
    end
  end

  context 'with valid values' do
    it 'name' do
      task = Task.new
      task.name = 'a' * 50
      expect(task.save).to eq(true)
    end

    it 'status' do
      task = Task.new
      task.name = 'a' * 50
      task.status = 1
      expect(task.save).to eq(true)
    end
  end

  context 'find with conditions' do
    it 'name and status' do
      todo_name1 = 'task1-todo'
      todo_name2 = 'task2-todo'
      done_name1 = 'task1-done'
      todo_task1 = Task.create(name: todo_name1, description: 'tmp', status: 'todo')
      todo_task2 = Task.create(name: todo_name2, description: 'tmp', status: 'todo')
      done_task1 = Task.create(name: done_name1, description: 'tmp', status: 'done')

      tasks = Task.find_with_conditions({'name' => '2-todo', 'status' => '0'})
      expect(tasks.length).to eq(1)
      expect(tasks.first.name).to eq(todo_name2)
    end
  end
end
