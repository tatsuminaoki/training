# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'has_secure_password' do
    it 'can use authenticate' do
      user = described_class.create(email: 'hoge@fuga.com', password: 'passw0rd')
      expect(user.authenticate('password')).to be_falsy
      expect(user.authenticate('passw0rd')).to be_truthy
    end
  end
end
