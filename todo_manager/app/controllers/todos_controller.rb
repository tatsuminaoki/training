class TodosController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, only: %i(detail edit update destroy)

  def index
    get_todos(current_user)
    render :index
  end

  def new
    set_todos
  end

  def create
    @todo = current_user.todos.new(
      title: params[:title],
      content: params[:content],
      priority_id: params[:todo][:priority_id],
      deadline: params[:deadline])

    set_labels('create')

    save_todos('create', root_path, :new)
  end

  def detail
    @todo = Todo.find_by(id: params[:id])
  end

  def edit
    @todo = Todo.find_by(id: params[:id])
    (NO_OF_LABELS - @todo.labels.count).times { @todo.labels.build }
  end

  def update
    @todo = Todo.find_by(id: params[:id])
    @todo.assign_attributes({
      title: params[:title],
      content: params[:content],
      priority_id: params[:todo][:priority_id],
      status_id: params[:todo][:status_id],
      deadline: params[:deadline]
    })

    set_labels('update')

    save_todos('update', "/todos/#{@todo.id}/detail", :edit)
  end

  def destroy
    @todo = Todo.find_by(id: params[:id])
    if @todo.destroy
      flash[:notice] = I18n.t('flash.todos.destroy.success')
      redirect_to(root_path)
    else
      flash.now[:notice] = I18n.t('flash.todos.destroy.failure')
      render :detail
    end
  end

  def ensure_correct_user
    @todo = Todo.find_by(id: params[:id])
    if current_user.user_type != 'admin' && current_user.id != @todo.user_id
      flash[:notice] = I18n.t('flash.users.authorization.failure')
      redirect_to(root_path)
    end
  end

end
