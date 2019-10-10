# frozen_string_literal: true

class Task < ApplicationRecord
  paginates_per 10
  validates :title, presence: true
  default_scope { order(created_at: :desc) }
  include AASM

  aasm do
    # 未着手
    state :not_yet, initial: true
    # 着手中
    state :on_going
    # 完了
    state :done

    event :start do
      transitions from: :not_yet, to: :on_going
    end

    event :finish do
      transitions from: :on_going, to: :done
    end

    event :restart do
      transitions from: %i[on_going done], to: :not_yet
    end
  end
end
