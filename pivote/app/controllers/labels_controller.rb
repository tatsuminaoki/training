# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :find_label, only: %i[edit update destroy]

  def index
    @labels = current_user.labels.page(params[:page])
  end

  def new
    @label = Label.new
  end
  
  def create
    @label = Label.new(label_params.merge(user_id: current_user.id))
    if @label.save
      redirect_to labels_url, notice: t('flash.create', target: @label.name)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      redirect_to labels_url, notice: t('flash.update', target: @label.name)
    else
      render :edit
    end
  end

  def destroy
    if @label.destroy
      redirect_to labels_url, notice: t('flash.delete', target: @label.name)
    else
      render :index
    end
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end

  def find_label
    @label = current_user.labels.find(params[:id])
  end
end
