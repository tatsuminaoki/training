# frozen_string_literal: true

class Task < ApplicationRecord
  # 間に差込で追加したいという要望に応えられるよう、値を10の倍数としている
  enum priority: { high: 10, middle: 20, low: 30 }
  enum status: { waiting: 10, doing: 20, done: 30 }
end
