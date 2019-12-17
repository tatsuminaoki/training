# frozen_string_literal: true

module ApplicationHelper
  def admin?
    logged_in? && current_user.admin?
  end
end
