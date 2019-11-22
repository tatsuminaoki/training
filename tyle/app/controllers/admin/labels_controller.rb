# frozen_string_literal: true

module Admin
  class LabelsController < ApplicationController
    before_action :label, only: %i[show edit update destroy]
    before_action :redirect_if_unauthorized

    def index
      @labels = Label.all
    end

    def new
      @label = Label.new
    end

    def create
      @label = Label.new(label_params)
      if @label.save
        redirect_to admin_label_path(@label), notice: t('message.label.created')
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      if @label.update(label_params)
        redirect_to admin_label_path(@label), notice: t('message.label.updated')
      else
        render :edit
      end
    end

    def destroy
      if @label.destroy
        redirect_to admin_labels_path, notice: t('message.label.destroyed')
      else
        redirect_to admin_labels_path
      end
    end

    private

    def label
      @label = Label.find(params[:id])
    end

    def label_params
      params.require(:label).permit(:name)
    end
  end
end
