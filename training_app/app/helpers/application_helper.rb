# frozen_string_literal: true

module ApplicationHelper
  def sign_out
    link_to t('logout'), sign_out_path, method: :delete \
      if current_user
  end
end
