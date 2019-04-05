class Maintenance < ApplicationRecord
  enum maintenance_enum: [:end, :start]
end
