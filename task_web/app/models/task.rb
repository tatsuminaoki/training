class Task < ApplicationRecord
  # TODO: 暫定版Validation ( Step11 で仕上げます)
  # 空チェック
  validates :name, :description, presence: true
  # タスク名の長さチェック
  validates :name, length: { maximum: 20 }
  # 説明文の長さチェック
  validates :description, length: { maximum: 200 }
end
