class Maintenance < ApplicationRecord
  enum is_maintenance: %i[end start]
end
