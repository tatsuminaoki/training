# frozen_string_literal: true

require 'rails_helper'
require 'rake'

describe 'maintenace_mode' do
  let(:maintenance_file) { 'tmp/maintenance.yml' }

  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require('maintenance_mode', [Rails.root.join('lib', 'tasks')])
    Rake::Task.define_task(:environment)
  end

  describe 'start' do
    let(:task_start) { 'maintenance_mode:start' }

    it 'メンテナンスモードのファイルがあること' do
      expect(@rake[task_start].invoke).to be_truthy
      expect(File.exist?(maintenance_file)).to be_truthy
    end
  end

  describe 'stop' do
    let(:task_end) { 'maintenance_mode:end' }

    it 'メンテナンスモードのファイルがないこと' do
      expect(@rake[task_end].invoke).to be_truthy
      expect(File.exist?(maintenance_file)).not_to be_truthy
    end
  end
end
