# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    id {0}
    title {'This is a Robot'}
    content {'Test Object'}
    status {0}
    end_time {'2018-09-27 00:16:35'}
  end
end
