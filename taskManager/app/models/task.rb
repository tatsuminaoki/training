class Task < ApplicationRecord
  enum status: { 'open': 1, 'in progress': 2, 'review': 3, 're:open': 4, 'done': 5 }
  enum priority: { 'highest': 1, 'higher': 2, 'middle': 3, 'lower': 4, 'lowest': 5 }
end
