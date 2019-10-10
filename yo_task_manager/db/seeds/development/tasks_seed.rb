# frozen_string_literal: true

users = User.all
users.each do |user|
  6.times { create(:task, user: user) }
end
