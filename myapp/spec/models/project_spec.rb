require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validates name' do
    context 'nameが正しく設定されている' do
      example 'バリデーションが通る' do
        expect(Project.new(name: 'test').valid?).to eq true
      end
    end

    context 'nameがnil' do
      example 'バリデーションが通らないし、エラーメッセージを返す' do
        project = Project.new(name: nil)
        project.valid?
        expect(project.errors.messages[:name]).to eq ["can't be blank"]
      end
    end

    context 'nameが空文字' do
      example 'バリデーションが通らないし、エラーメッセージを返す' do
        project = Project.new(name: '')
        project.valid?
        expect(project.errors.messages[:name]).to eq ["can't be blank"]
      end
    end
  end

  describe 'method create!' do
    context 'create!が成功' do
      example 'projectが作成されて、紐ついてるgroupsも作成される' do
        Project.new(name: 'test').create!

        expect(Project.count).to eq 1
        expect(Group.count).to eq 4
      end
    end
  end
end
