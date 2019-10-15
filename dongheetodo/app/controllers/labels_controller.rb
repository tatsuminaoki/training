class LabelsController < ApplicationController
  before_action :authenticate

  def index
    @label = Label.new
    select_labels
  end

  def create
    begin
      @label = Label.new(label_params)
      if @label.save
        flash[:success] = t("message.success.complete_create")
        redirect_to labels_path
      else
        select_labels
        render "index"
      end
    rescue ArgumentError => e
      @label = Label.new
      @label.errors.messages[:"color"] = [t('message.error.invaild_param')]
      select_labels
      render "index"
    end
  end

  def destroy

  end

  private

  def label_params
    params.require(:label).permit(:name, :color)
  end

  def select_labels
    @labels = Label.all.page(params[:page]).per(20)
  end
end
