class Maintenance < ApplicationRecord
  validates :maintenance_mode, default: false
end
