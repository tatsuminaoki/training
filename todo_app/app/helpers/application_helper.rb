# frozen_string_literal: true

module ApplicationHelper
  include Sessions

  def active_action(*action)
    return 'active' if action.include?(params[:action])
  end

  delegate :administrator?, to: :current_user, allow_nil: true
end
