class Label < ApplicationRecord
  belongs_to :task
  belongs_to :label_type
end
