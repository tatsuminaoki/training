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

  # rubocop:disable Style/TrailingCommaInArguments
  describe 'validations' do
    describe 'password' do
      it 'cant be blank' do
        user = build(:user, password: 'password').tap(&:valid?)
        expect(
          user.errors.details[:password].any? { |r| r[:error] == :blank }
        ).to be_falsy

        user = build(:user, password: nil).tap(&:valid?)
        expect(
          user.errors.details[:password].any? { |r| r[:error] == :blank }
        ).to be_truthy
      end

      it 'should be grater than or equal to 8 char' do
        user = build(:user, password: 'password').tap(&:valid?)
        expect(
          user.errors.details[:password].any? { |r| r[:error] == :too_short }
        ).to be_falsy

        user = build(:user, password: 'pass').tap(&:valid?)
        expect(
          user.errors.details[:password].any? { |r| r[:error] == :too_short }
        ).to be_truthy
      end
    end
  end
  # rubocop:enable Style/TrailingCommaInArguments
end
