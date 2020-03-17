class StaticController < ApplicationController
  skip_before_action :current_user, if: :signed_in?
  skip_before_action :require_sign_in!

  def index
    redirect_to projects_path if signed_in?
  end
end
