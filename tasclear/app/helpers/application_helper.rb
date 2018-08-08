# frozen_string_literal: true

module ApplicationHelper
  def user_labels
    labels = []
    Label.all.each do |label|
      label.tasks.includes(:user).each do |task|
        labels << label.name if task.user == current_user
      end
    end
    labels.uniq
  end
end
