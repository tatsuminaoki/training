# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  body       :text(65535)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Task < ApplicationRecord
end
