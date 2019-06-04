# frozen_string_literal: true

require 'rails_helper'
require 'rake'

describe 'maintenace_mode' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require('maintenance_mode', [Rails.root.join('lib', 'tasks')])
    Rake::Task.define_task(:environment)
  end

  describe 'start' do
    context 'when not maintenance mode' do
      it 'turn on' do
        MaintenanceMode.start
        expect(File.exist?(Constants::MAINTENANCE_FILE)).to be_truthy
      end
    end

    context 'when maitenance mode' do
      before { FileUtils.touch(Constants::MAINTENANCE_FILE) }

      it 'do not raise any errors' do
        MaintenanceMode.start
        expect(File.exist?(Constants::MAINTENANCE_FILE)).to be_truthy
      end
    end
  end

  describe 'stop' do
    context 'when not maintenance mode' do
      it 'do not raise any errors' do
        MaintenanceMode.stop
        expect(File.exist?(Constants::MAINTENANCE_FILE)).to be_falsey
      end
    end

    context 'when maintenance mode' do
      before { FileUtils.touch(Constants::MAINTENANCE_FILE) }

      it 'turn off maintenance mode' do
        MaintenanceMode.stop
        expect(File.exist?(Constants::MAINTENANCE_FILE)).to be_falsey
      end
    end
  end
end
