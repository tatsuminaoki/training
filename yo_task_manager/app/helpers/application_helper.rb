# frozen_string_literal: true

module ApplicationHelper
  def active_path?(path)
    return 'active' if request.path == path
    ''
  end
end
