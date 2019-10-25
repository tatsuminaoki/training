# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  let(:user) { create(:user) }
  let(:label) { create(:label) }
  let!(:task) { create(:task, user: user, labels: [label]) }
  let!(:labeling) { Labeling.find_by(label_id: label) }
  describe 'dependent destroy on labeling' do
    it 'when label get destroyed' do
      label.destroy
      expect { label.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { labeling.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
