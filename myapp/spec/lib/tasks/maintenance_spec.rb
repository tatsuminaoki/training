# frozen_string_literal: true

require 'rails_helper'
require 'rake'

describe 'maintenance' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require('maintenance', ["#{Rails.root}/lib/tasks"])
    Rake::Task.define_task(:environment)
  end


  describe 'maintenance:start' do
    it 'returns hoge' do
      expect(@rake['maintenance:start'].invoke).to be_truthy

      data = open('config/maintenance.yml', 'r') { |f| YAML.load(f) }
      expect(data["maintenance_mode"]).to eq true
    end
  end

  describe 'maintenance:end' do
    it 'returns hoge' do
      expect(@rake['maintenance:end'].invoke).to be_truthy

      data = open('config/maintenance.yml', 'r') { |f| YAML.load(f) }
      expect(data["maintenance_mode"]).to eq false
    end
  end
end

