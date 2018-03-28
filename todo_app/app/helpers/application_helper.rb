# frozen_string_literal: true

module ApplicationHelper
  def active_action(*action)
    return 'active' if action.include?(params[:action])
  end

  def submit_btn_name(type: :new)
    return I18n.t('helpers.submit.create') if type == :new
    return I18n.t('helpers.submit.update') if type == :edit
  end
end
