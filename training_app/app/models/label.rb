# == Schema Information
#
# Table name: labels
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Label < ApplicationRecord
  has_many :task_labels
  has_many :task, through: :task_labels
end
