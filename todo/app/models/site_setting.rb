# frozen_string_literal: true

class SiteSetting < ApplicationRecord
  enum maintenance: %i[off on]
end
