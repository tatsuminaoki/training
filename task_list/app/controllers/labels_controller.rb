class LabelsController < ApplicationController
  before_action :set_label, only: %i[destroy]
  before_action :login_check, only: %i[new destroy index]
  before_action :check_label_auther, only: %i[destroy]

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)
    @label.user_id = current_user.id
    if @label.save
      redirect_to labels_path, notice: I18n.t('activerecord.flash.label_create')
    else
      flash[:alert] = "#{@label.errors.count}件のエラーがあります"
      render 'new'
    end
  end

  def index
    @labels = current_user.labels
  end

  def destroy
    @label.destroy
    redirect_to labels_path, notice: I18n.t('activerecord.flash.label_delete')
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end

  def set_label
    @label = Label.find(params[:id])
  end

  def check_label_auther
    set_label
    redirect_to tasks_path, alert: '作成者以外はラベルの削除はできません' if current_user.id != @label.user_id
  end

  def login_check
    redirect_to new_session_path, alert: 'ログインしてください' if session[:user_id].nil?
  end
end
