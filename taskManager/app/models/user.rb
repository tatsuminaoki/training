class User < ApplicationRecord
  has_many :task, dependent: :destroy

  validates :mail,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
            length: { maximum: 255 }

  validates :user_name,
            presence: true,
            format: { with: /\A[\wぁ-んァ-ン一-龥]+[\s　]?[\wぁ-んァ-ン一-龥]+\z/ },
            length: { maximum: 255 }

  validates :encrypted_password, presence: true
end
