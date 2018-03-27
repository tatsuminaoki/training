class LabelsController < ApplicationController
  def index
    @lables = ActsAsTaggableOn::Tag.order(:name).pluck(:name)
  end
end
