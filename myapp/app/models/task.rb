class Task < ApplicationRecord
  enum priority: { HIGH: 0, MIDDLE: 1, LOW: 2 }
end
