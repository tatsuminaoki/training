# frozen_string_literal: true

module ApplicationHelper
  def hyphen_if_blank(value)
    value.presence || '-'
  end
end
