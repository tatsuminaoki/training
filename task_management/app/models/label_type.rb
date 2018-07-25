class LabelType < ApplicationRecord
  has_many :tasks, through: :labels
  has_many :labels
end
