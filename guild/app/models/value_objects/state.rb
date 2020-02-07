module ValueObjects
  class State < ValueObjects::Base
    def self.get_list
      {
        1 => I18n.t(:state)[:open],
        2 => I18n.t(:state)[:doing],
        3 => I18n.t(:state)[:done],
        4 => I18n.t(:state)[:pending],
        5 => I18n.t(:state)[:close],
      }
    end

    def get_text
      list = State.get_list
      list[@value]
    end
  end
end
