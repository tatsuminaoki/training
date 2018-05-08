class UsersController < ApplicationController
  include SortUtility

  before_action :set_user, only: [:show, :edit, :tasks, :update, :destroy]

  helper_method :sort_column, :sort_order

  before_action AdminFilter.new

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # GET /users/1/tasks
  def tasks
    sort = sort_column Task, 'created_at'
    order = sort_order

    label_models = Label.where('user_id is null or user_id = ?', params[:id].to_i)
    @labels = Hash.new
    @labels.store(I18n.t('labels.all'), '0')
    label_models.each do |label|
      @labels.store(label.label, label.id)
    end

    @tasks = Task.order("#{sort} #{order}")

    # ログインユーザで絞込
    @tasks = @tasks.get_by_user_id(params[:id])
    # ステータスが指定されていたら絞込
    if params[:status].present? && params[:status].to_i > 0
      @tasks = @tasks.get_by_status(params[:status])
    end

    # ラベルが指定されていたら絞込
    if params[:label].present? && params[:label].to_i > 0
      task_ids = TaskToLabel.where(label_id: params[:label].to_i).pluck(:task_id)
      @tasks = @tasks.where(id: task_ids)
    end

    # キーワードが指定されていたら絞込
    if params[:keyword].present?
      @tasks = @tasks.get_by_keyword(params[:keyword])
    end

    # Pagenation
    @tasks = Kaminari.paginate_array(@tasks).page(params[:page])

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(login_id: user_params[:login_id], admin_flag: user_params[:admin_flag])
    password = user_params[:password]

    message = User.check_valid(@user.login_id, password)

    if message.present?
      flash.now[:notice] = message
      render 'new'
    else
      @user.password_hash = User.password_hash(@user.login_id, password)

      if !@user.save
        flash.now[:notice] = @user.errors.full_messages[0]
        render 'new'
        return
      end

      redirect_to '/admin/users', notice: t('notices.created', model: t('activerecord.models.user'))
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    update_check = successor_check(@user, user_params)
    if update_check && @user.update(user_params)
      # 自分を管理者から除外した場合はタスク一覧へ
      if @user.id == session[:user]['id'] && !@user.admin_flag
        redirect_to tasks_path
      else
        redirect_to @user, notice: t('notices.updated', model: t('activerecord.models.user'))
      end
    else
      flash.now[:notice] = @user.errors.full_messages[0]
      render 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    delete_check = successor_check(@user, @user.attributes)
    if delete_check && @user.destroy
      # 自分を削除した場合はログアウト
      if @user.id == session[:user]['id']
        redirect_to logout_path
      else
        redirect_to users_url, notice: t('notices.deleted', model: t('activerecord.models.user'))
      end
    else
      redirect_to users_url, notice: @user.errors.full_messages[0]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:login_id, :admin_flag, :password)
    end

    def successor_check(user, user_params)
      return true if user_params[:admin_flag] == '1'
      return true if User.where(admin_flag: true).count > 1
      if User.where(admin_flag: true).first.id == user.id
        user.errors.add(:admin_flag, I18n.t('activerecord.errors.messages.need_successor'))
        return false
      end
      true
    end
end
