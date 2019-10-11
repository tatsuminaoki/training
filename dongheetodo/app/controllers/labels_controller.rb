class LabelsController < ApplicationController
  before_action :authenticate

  def index
    @label = Label.new
    select_labels
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      flash[:success] = t("message.success.complete_create")
    end
    select_labels
    render "index"
  end

  def destroy

  end

  private

  def label_params
    params.require(:label).permit(:name, :color)
  end

  def select_labels
    @labels = Label.all.includes(:tasks).page(params[:page]).per(20)
  end
end
