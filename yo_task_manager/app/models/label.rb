# frozen_string_literal: true

class Label < ApplicationRecord
  has_many :labelings, dependent: :destroy
  has_many :tasks, through: :labellings
end
