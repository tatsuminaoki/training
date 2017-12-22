RSpec::Matchers.define :require_login do |expected|
  match do |actual|
    expect(actual).to redirect_to Rails.application.routes.url_helpers.logins_new_path
  end

  failure_message do |actual|
    "ログインを要求していません"
  end

  failure_message_when_negated do |actual|
    "ログインが要求されています"
  end

  description do |actual|
    "ログインが要求される"
  end
end
