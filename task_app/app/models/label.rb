# frozen_string_literal: true

class Label < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 10 }, uniqueness: { scope: :user_id } # user_idとnameの組み合わせが一意であること
end
