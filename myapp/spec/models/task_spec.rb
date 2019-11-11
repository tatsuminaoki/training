require 'rails_helper'

RSpec.describe Task, type: :model do
  context "with invalid values" do
    it "blank name" do
      task = Task.new
      expect(task.save).to eq(false)
    end

    it "name too long" do
      task = Task.new
      task.name = 'a' * 51
      expect(task.save).to eq(false)
    end

    it "status" do
      task = Task.new
      task.name = 'a' * 50
      # expect() seems doesn't work for this
      expect {task.status = 4}.to raise_error(ArgumentError)
    end
  end

  context "with valid values" do
    it "name" do
      task = Task.new
      task.name = 'a' * 50
      expect(task.save).to eq(true)
    end

    it "status" do
      task = Task.new
      task.name = 'a' * 50
      task.status = 1
      expect(task.save).to eq(true)
    end
  end
end
