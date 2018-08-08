# frozen_string_literal: true

module ApplicationHelper
  def user_labels
    Label.joins(:tasks).where('tasks.user_id = ?', current_user.id).pluck(:name).uniq
  end
end
