class Label < ApplicationRecord
  belongs_to :task
  belongs_to :user_label
end
