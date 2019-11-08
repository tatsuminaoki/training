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
  end

  context "with valid values" do
    it "name" do
      task = Task.new
      task.name = 'a' * 50
      expect(task.save).to eq(true)
    end
  end
end
