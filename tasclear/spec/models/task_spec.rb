# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'タスク名と内容があれば有効な状態であること' do
    task = Task.new(
      name: '家事',
      content: '掃除、洗濯',
    )
    expect(task).to be_valid
  end
end
