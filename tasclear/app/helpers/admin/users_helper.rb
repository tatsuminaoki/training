# frozen_string_literal: true

module Admin::UsersHelper
  def tasks_amount(user)
    user.tasks.count
  end
end
