# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: { yet: 0, do: 1, done: 2 }
end
