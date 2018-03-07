class StatusType < ApplicationRecord
  def self.all
    %w(not_start in_progress done)
  end
end