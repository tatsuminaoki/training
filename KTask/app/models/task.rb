# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: [:yet, :do, :done]
end
