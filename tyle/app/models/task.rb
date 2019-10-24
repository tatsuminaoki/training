class Task < ApplicationRecord
  belongs_to :user
  enum priority: %i[low medium high]
  enum status: %i[waiting in_progress done]
end
