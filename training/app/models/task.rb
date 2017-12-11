class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :user_id, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :priority, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :status, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :label_id, :numericality => { :greater_than_or_equal_to => 0, :allow_blank => true }

end
