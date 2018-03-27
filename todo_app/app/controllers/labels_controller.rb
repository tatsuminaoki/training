class LabelsController < ApplicationController
  before_action :require_login

  def index
    @lables = ActsAsTaggableOn::Tag.order(:name).pluck(:name)
  end

  private

  def require_login
    redirect_to login_path unless logged_in?
  end
end
