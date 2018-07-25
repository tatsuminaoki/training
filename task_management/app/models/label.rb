class Label < ApplicationRecord
  belongs_to :task, optional: true
  belongs_to :label_type
end
