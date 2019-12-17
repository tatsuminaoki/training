# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
  let(:user) { create(:user) }

  describe 'when use log_in' do
    context 'with user instance' do
      it 'session contains user id' do
        log_in(user)
        expect(session[:user_id]).to eq(user.id)
      end
    end
  end

  describe 'when use log_out' do
    context 'with having user session' do
      it 'removed user info from session' do
        log_in(user)
        log_out
        expect(session[:user_id]).not_to eq(user.id)
      end
    end
  end

  describe 'when use current_user' do
    context 'with logged-in user' do
      it 'return user' do
        log_in(user)
        expect(current_user).to eq(user)
      end
    end

    context 'with logged-out user' do
      it 'return nothing' do
        log_in(user)
        log_out
        expect(current_user).not_to eq(user)
      end
    end
  end

  describe 'when use logged_in?' do
    context 'with logged-in user' do
      it 'return true' do
        log_in(user)
        expect(logged_in?).to be_truthy
      end
    end

    context 'with logged-out user' do
      it 'return false' do
        log_in(user)
        log_out
        expect(logged_in?).to be_falsey
      end
    end
  end
end
