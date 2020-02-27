class Task < ApplicationRecord
  belongs_to :group

  enum priority: { high: 0, middle: 1, low: 2 }
end
