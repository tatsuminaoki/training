class LabelsController < ApplicationController
  PER = 8

  before_action :set_label, only: [:show, :edit, :update, :destroy]

  def index
    search = current_user.labels.ransack(params[:q])
    @search_labels = search.result.page(params[:page]).per(PER)
  end

  def show
  end

  def new
    @label = Label.new
  end

  def edit
  end

  def create
    @label = current_user.labels.new(label_params)

    if @label.save
      redirect_to @label,
                  notice: I18n.t('notification.create', value: @label.name)
    else
      render :new
    end
  end

  def update
    if @label.update(label_params)
      redirect_to labels_url,
                  notice: I18n.t('notification.update', value: @label.name)
    else
      render :edit
    end
  end

  def destroy
    @label.destroy
    redirect_to labels_url,
                notice: I18n.t('notification.destroy', value: @label.name)
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end

  def set_label
    @label = current_user.labels.find(params[:id])
  end
end
