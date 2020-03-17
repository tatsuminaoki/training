class StaticController < ApplicationController
  skip_before_action :current_user
  skip_before_action :require_sign_in!

  def index
  end
end
