module FeatureSpecHelper
  def login_as(user)
    allow_any_instance_of(ApplicationController).to receive(:current_user) { user }
  end

  def submit_form
    find('input[name="commit"]').click
  end
end
