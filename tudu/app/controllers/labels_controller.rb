class LabelsController < ApplicationController
  before_action :ensure_log_in_user!

  def index
    @labels = Label.where(user_id: current_user.id).all().order('created_at desc')
  end

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.build(label_params)
    if @label.save
      flash[:success] = t('label.create.success')
      redirect_to labels_url
    else
      render 'new'
    end
  end

  def edit
    @label = Label.find(params[:id])
  end

  def update
    @label = Label.find(params[:id])
    if @label.update_attributes(label_params)
      flash[:success] = t('label.update.success')
      redirect_to labels_url
    else
      render 'edit'
    end
  end

  def destroy
    Label.find(params[:id]).destroy
    flash[:success] = t('label.delete.success')
    redirect_to labels_url
  end

  private

  def label_params
    params.require(:label).permit(
      :name
    )
  end
end
