class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  enum status: [ :todo, :processing, :done ]

  def readable_status
    Task.human_attribute_name("status.#{self.status}")
  end

  def self.readable_statuses
    Task.statuses.map {|k,v| [Task.human_attribute_name("status.#{k}"),v]}.to_h
  end
end
