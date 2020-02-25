class Task < ApplicationRecord
  enum priority: { high: 0, middle: 1, low: 2 }
end
