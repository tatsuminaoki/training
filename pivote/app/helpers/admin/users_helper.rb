# frozen_string_literal: true

module Admin
  module UsersHelper
    def admin_icon(is_admin)
      is_admin ? '○' : '×'
    end
  end
end
