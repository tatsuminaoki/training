# frozen_string_literal: true

module ApplicationHelper
  def active_action(*action)
    return 'active' if action.include?(params[:action])
  end
end
