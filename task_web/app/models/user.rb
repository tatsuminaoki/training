# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :recoverable, :rememberable,
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable

  # ユーザ名のチェック
  validates :name, presence: true, length: { maximum: 20 }
  # auth_level

end
# create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
#   t.string "login_id"
#   t.string "name"
#   t.string "password"
#   t.integer "auth_level"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end
