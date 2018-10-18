require 'rails_helper'

RSpec.describe Label, type: :model do
  context '登録テスト' do
    it "ラベル名があれば有効な状態であること" do
      expect(FactoryBot.build(:label)).to be_valid
    end
    it "ラベル名が無ければ、無効な状態であること" do
      label = FactoryBot.build(:label, label_name: nil)
      label.valid?
      expect(label.errors[:label_name]).to include("ラベル名が空です。")
    end
    it "重複したメールアドレスなら無効な状態であること" do
      FactoryBot.create(:label, label_name: "label1")
      label = FactoryBot.build(:label, label_name: "label1")
      label.valid?
      expect(label.errors[:label_name]).to include("は既に登録済みです。")
    end
  end
end
