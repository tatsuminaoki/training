class Admin::UsersController < ApplicationController
  before_action :check_permission

  def index
    @users = User.includes(task: :user).page(params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(id: params[:id])
    @tasks = Task.includes(task_label: :label).search(params: params, user: @user).page(params[:page])
    if sort_direction.present? && sort_column.present?
      @tasks = @tasks.order("#{sort_column}": sort_direction)
    else
      @tasks = @tasks.order(created_at: :desc)
    end
  end

  def create
    @user = User.new(common_params)
    result = @user.save

    if result
      flash[:info] = make_simple_message(column: 'user', action: 'new')
      redirect_to :action => 'index'
    else
      flash.now[:warning] = make_simple_message(column: 'user', action: 'new', result: false)
      render action: 'new'
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
    render action: 'new'
  end

  def update
    @user = User.find_by(id: params[:id])
    result = @user.update(common_params)

    if result
      flash[:info] = make_simple_message(column: 'user', action: 'edit')
      redirect_to :action => 'index'
    else
      flash.now[:warning] = make_simple_message(column: 'user', action: "edit", result: false)
      render action: 'new'
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    result = @user.destroy

    if result
      flash[:info] = make_simple_message(column: 'user', action: 'delete')
      if User.current.id == params[:id].to_i
        delete_session
        return redirect_to logout_path
      end
    else
      flash[:warning] = make_simple_message(column: 'user', action: 'delete', result: false)
    end

    redirect_to :action => 'index'
  end

  private

  def common_params
    params.require(:user).permit(
      :user_name, :mail, :password, :password_confirmation, :role
    )
  end

  def check_permission
    unless User.current.admin?
      flash.now[:warning] = I18n.t('messages.permission_error')
      render 'errors/permission'
    end
  end
end
