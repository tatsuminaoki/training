# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: { 未着手: 'yet', 着手: 'do', 完了: 'done' }
end
