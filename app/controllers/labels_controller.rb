# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :label, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_unauthorized

  def index
    @labels = Label.all.order(created_at: :desc)
  end

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)

    if @label.save
      redirect_to @label, success: t('messages.created', item: @label.model_name.human)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      redirect_to @label, success: t('messages.updated', item: @label.model_name.human)
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    @label.destroy!
    redirect_to labels_url, success: t('messages.deleted', item: @label.model_name.human)
  end

  private

  def label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(
      :name,
    )
  end
end
