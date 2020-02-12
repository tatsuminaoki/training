# frozen_string_literal: true

module ValueObjects
  class Label < ValueObjects::Base
    def self.get_list
      {
        1 => I18n.t(:label)[:bugfix],
        2 => I18n.t(:label)[:support],
        3 => I18n.t(:label)[:research],
        4 => I18n.t(:label)[:implement],
        5 => I18n.t(:label)[:other],
      }
    end

    def get_text
      list = Label.get_list
      list[@value]
    end
  end
end
