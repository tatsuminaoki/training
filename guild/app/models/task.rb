# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :subject, presence: true
  validates :state, presence: true, inclusion: { in: ValueObjects::State.get_list.keys }
  validates :priority, presence: true, inclusion: { in: ValueObjects::Priority.get_list.keys }
  validates :label, presence: true, inclusion: { in: ValueObjects::Label.get_list.keys }
end
