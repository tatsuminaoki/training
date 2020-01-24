module ValueObjects
  class Label < ValueObjects::Base
    def self.get_list
      {
        1 => 'Bugfix',
        2 => 'Support',
        3 => 'Research',
        4 => 'Implement',
        5 => 'Other'
      }
    end

    def get_text
      list = Label.get_list
      list[@value]
    end
  end
end
