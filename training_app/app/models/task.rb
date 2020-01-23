# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  status     :integer          default("todo"), not null
#  title      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_tasks_on_status  (status)
#

class Task < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true

  enum status: {
    todo: 0,
    progress: 1,
    done: 2,
  }

  def self.status_name(status)
    I18n.t("activerecord.enums.task.status.#{status}")
  end

  def status_name
    self.class.status_name(self.status)
  end
end
