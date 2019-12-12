# frozen_string_literal: true

module Admin
  module UsersHelper
    def user_roles
      { '一般' => 'general', '管理者' => 'admin' }
    end
  end
end
