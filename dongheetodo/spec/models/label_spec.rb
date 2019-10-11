require 'rails_helper'

RSpec.describe TaskLabel, type: :model do

  let(:name) { Faker::Food.fruits }
  let(:color) { Label.colors.keys.sample }

  describe '#create' do
    context '有効な値で生成する場合' do
      it '正常に生成されること' do
        label = Label.new(name: name, color: color)
        label.valid?
        expect(label).to be_truthy
      end
    end

    context '同じラベル名でもう一回生成する場合' do
      it '重複エラーが発生すること' do
        label1 = Label.create(name: name, color: color)
        label2 = Label.new(name: name, color: color)
        label2.valid?
        expect(label2.errors.messages[:name]).to include "はすでに存在します"
      end
    end

    context '256文字以上のラベル名を指定する場合' do
      it 'エラーが発生すること' do
        label = Label.new(name: Faker::String.random(length: 256), color: color)
        label.valid?
        expect(label.errors.messages[:name]).to include "は255文字以内で入力してください"
      end
    end

    context '定義されてない値をカラーに指定する場合' do
      it '引数エラーが発生すること' do
        expect{ Label.new(name: name, color: 999) }.to raise_error ArgumentError
      end
    end

  end

end
