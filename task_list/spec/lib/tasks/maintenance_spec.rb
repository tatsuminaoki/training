# frozen_string_literal: true.
require 'rails_helper'
require 'rake'

describe 'maintenance' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require 'maintenance'
    Rake::Task.define_task(:environment)
  end

  let!(:task_start) { 'maintenance:start' }
  let!(:task_finish) { 'maintenance:finish' }

  it 'メンテナンスが始まること' do
    @rake[task_start].invoke
    expect(Maintenance.last.is_maintenance).to eq('start')
  end

  it 'メンテナンスが終了すること' do
    maintenance = create(:maintenance)
    @rake[task_finish].invoke
    expect(Maintenance.last.is_maintenance).to eq('end')
  end
end
