module ValueObjects
  class State < ValueObjects::Base
    def self.get_list
      {
        1 => 'Open',
        2 => 'Doing',
        3 => 'Done',
        4 => 'Pending',
        5 => 'Close'
      }
    end

    def get_text
      list =State.get_list
      list[@value]
    end
  end
end
