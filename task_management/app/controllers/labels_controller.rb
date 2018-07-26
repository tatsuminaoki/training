class LabelsController < ApplicationController
  def index
    @labels = LabelType.all
  end

  def edit
    @label = LabelType.find(params[:id])
  end

  def new
    @label = LabelType.new
  end

  def destroy
    @label = LabelType.find(params[:id])
    if @label.destroy
      redirect_to ({action: 'index'}), notice: I18n.t('flash.success_delete_label', label: @label.label_name)
    else
      redirect_to ({action: 'edit'}), id: params[:id], alert: I18n.t('flash.failure_delete_label', label: @label.label_name)
    end
  end

  def create
    @label = LabelType.new(label_types_params)
    if @label.save
      redirect_to ({action: 'index'}), notice: I18n.t('flash.success_create_label')
    else
      flash.now[:alert] = I18n.t('flash.failure_create_label')
      render :new
    end
  end

  def update
    @label = LabelType.find(params[:id])
    if @label.update_attributes(label_types_params)
      redirect_to ({action: 'index'}), notice: I18n.t('flash.success_update_label')
    else
      flash.now[:alert] = I18n.t('flash.failure_update_label')
      render :edit
    end
  end

  def label_types_params
    params.require(:label_type).permit(:label_name)
  end
end
