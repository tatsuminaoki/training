# frozen_string_literal: true

module ApplicationHelper
  def user_labels
    labels = []
    Label.all.includes(:tasks).each do |label|
      label.tasks.each do |task|
        labels << label.name if task.user == current_user
      end
    end
    labels
  end
end
