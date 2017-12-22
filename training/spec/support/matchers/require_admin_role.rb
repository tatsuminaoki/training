RSpec::Matchers.define :require_admin_role do |expected|
  match do |actual|
    expect(actual).to redirect_to Rails.application.routes.url_helpers.root_path
    expect(flash[:notice]).to eq I18n.t('application.controller.messages.role_error')
  end

  failure_message do |actual|
    "管理者権限を要求していません"
  end

  failure_message_when_negated do |actual|
    "管理者権限が要求されています"
  end

  description do |actual|
    "管理者権限が要求される"
  end
end
