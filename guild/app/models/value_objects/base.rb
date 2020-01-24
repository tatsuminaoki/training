module ValueObjects
  class Base
    def initialize(value)
      @value = value
    end

    def get_value
      @value
    end
  end
end
