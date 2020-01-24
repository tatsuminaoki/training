module ValueObjects
  class Priority < ValueObjects::Base
    def self.get_list
      {
        1 => 'Low',
        2 => 'Middle',
        3 => 'High',
      }
    end

    def get_text
      list =State.get_list
      list[@value]
    end
  end
end
