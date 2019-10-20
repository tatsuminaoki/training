# frozen_string_literal: true

module ApplicationHelper
  def is_current_path(path)
    return 'active' if request.path == path
  end
end
