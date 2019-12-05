# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "when valid" do
    context "with valid attribute" do
      it { expect(user).to be_valid }
    end
  end

  describe "when not valid" do
    context "without a password" do
      let(:user_without_password) { build(:user, password: nil) }
      it { expect(user_without_password).not_to be_valid }
    end

    context "without a name" do
      let(:user_without_name) { build(:user, name: nil) }
      it { expect(user_without_name).not_to be_valid }
    end

    context "with duplicate name" do
      let(:user_duplicate_name) { build(:user) }
      it {
        expect(user).to be_valid
        expect(user_duplicate_name).not_to be_valid
      }
    end
  end
end
