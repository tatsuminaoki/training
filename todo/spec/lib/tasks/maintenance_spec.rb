# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'maintenance' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require('maintenance', [Rails.root.join('lib', 'tasks')])
    Rake::Task.define_task(:environment)
  end

  before(:each) do
    @rake[task].reenable
  end

  describe 'maintenance:on' do
    let(:task) { 'maintenance:on' }

    it 'should success.' do
      @rake[task].invoke
      site_setting = SiteSetting.first
      expect(site_setting.maintenance).to eq 'on'
    end
  end

  describe 'maintenance:off' do
    let(:task) { 'maintenance:off' }

    it 'should success.' do
      @rake[task].invoke
      site_setting = SiteSetting.first
      expect(site_setting.maintenance).to eq 'off'
    end
  end
end
