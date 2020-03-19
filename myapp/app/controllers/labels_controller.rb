class LabelsController < ApplicationController
  before_action :find_label, only: [:update]

  def update
    @label.update(request_params)
    if @label.save
      redirect_to project_url(id: @label.project.id), alert: I18n.t('flash.success_updated', model_name: 'label')
    else
      flash[:alert] = I18n.t('flash.failed_update', model_name: 'label')
      redirect_to project_url(id: @label.project.id), notice: @label.errors.full_messages
    end
  end

  private

  def find_label
    @label ||= Label.find_by!(id: params[:id])
  end

  def request_params
    params.require(:label).permit(:name, :color)
  end
end
