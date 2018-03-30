class LabelsController < ApplicationController
  before_action :require_login

  def index
    @page = params[:page]
    @labels = Task.label_all(page: @page)
  end

  private

  def require_login
    redirect_to login_path unless logged_in?
  end
end
