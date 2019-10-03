# frozen_string_literal: true

module TasksHelper
  def search_params(user_id, _status)
    'tasks?user_id=' + user_id.to_s + '&status=' + @status.to_s
  end
end
