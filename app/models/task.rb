# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: { waiting: 1, work_in_progress: 2, completed: 3 }
end
