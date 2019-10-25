# frozen_string_literal: true

require 'factory_bot'
include FactoryBot::Syntax::Methods

FactoryBot.definition_file_paths = [Rails.root.join('spec', 'factories')]
FactoryBot.reload

table_names = %w[
  users
  labels
  tasks
]
table_names.each do |table_name|
  path = Rails.root.join('db', 'seeds', Rails.env, table_name + '_seed.rb')
  next unless File.exist?(path)
  Rails.logger.info "Creating #{table_name}..."
  require path
  Rails.logger.info "#{table_name} creation finished!"
end
