module ValueObjects
  class Priority < ValueObjects::Base
    def self.get_list
      {
        1 => I18n.t(:priority)[:low],
        2 => I18n.t(:priority)[:middle],
        3 => I18n.t(:priority)[:high],
      }
    end

    def get_text
      list = Priority.get_list
      list[@value]
    end
  end
end
