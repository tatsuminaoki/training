# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :set_label, only: %i[edit update destroy]
  before_action :user_is_logged_in

  def index
    @q = Label.all.ransack(params[:q])
    @labels = @q.result(distinct: true).page(params[:page])
  end

  def new
    @label = Label.new
  end

  # rubocop:disable Metrics/AbcSize
  def create
    @label = Label.new(label_params)
    if @label.save
      flash[:success] = [t('.label_saved')]
      redirect_to labels_path
    else
      flash.now[:danger] = [(t('something_is_wrong') + t('labels.label_is_not_saved')).to_s, @label.errors.full_messages].flatten
      render :new
    end
  end
  # rubocop:enable Metrics/AbcSize

  def edit; end

  # rubocop:disable Metrics/AbcSize
  def update
    if @label.update(label_params)
      flash[:success] = [t('.label_updated')]
      redirect_to labels_path
    else
      flash.now[:danger] = [(t('something_is_wrong') + t('labels.label_is_not_updated')).to_s, @label.errors.full_messages].flatten
      render :edit
    end
  end
  # rubocop:enable Metrics/AbcSize

  def destroy
    if @label.destroy
      flash[:success] = [t('.label_deleted')]
    else
      flash[:danger] = [(t('something_is_wrong') + t('labels.label_is_not_destroyed')).to_s, @label.errors.full_messages].flatten
    end
    redirect_to labels_path
  end

  private

  def set_label
    @label = Label.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = [t('labels.label_not_found')]
    redirect_to labels_path
  end

  def label_params
    params.require(:label).permit(:name)
  end
end
