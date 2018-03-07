class PriorityType < ApplicationRecord
  def self.all
    %w(low normal high quickly right_now)
  end
end