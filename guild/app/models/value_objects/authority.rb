module ValueObjects
  class Authority < ValueObjects::Base
    def self.get_list
      {
        1 => I18n.t(:authority)[:member],
        2 => I18n.t(:authority)[:admin],
      }
    end

    def get_text
      list = self.class.get_list
      list[@value]
    end
  end
end
