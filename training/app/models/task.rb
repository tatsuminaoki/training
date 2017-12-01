class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }

  def self.create_task(name, description = nil)
    create(name: name, description: description)
  end
end
