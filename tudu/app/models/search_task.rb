class SearchTask
  include ActiveModel::Model

  PER_PAGE = 10

  SORT = [
    'expire_date'
  ]

  ORDER = [
    'asc', 'desc'
  ]

  def initialize(params, user_id)
    self.filtered_params = params.permit(
      :q, :status, :sort, :order, :page
    )

    self.q = self.filtered_params[:q] if self.filtered_params[:q].present?
    self.status = self.filtered_params[:status] if self.filtered_params[:status].present?
    self.sort = self.filtered_params[:sort] if self.filtered_params[:sort].present?
    self.order = self.filtered_params[:order] if self.filtered_params[:order].present?
    self.page = self.filtered_params[:page] if self.filtered_params[:page].present?

    self.user_id = user_id
  end

  def execute
    task = Task.all
    task = task.where(status: self.status) if self.status.present?
    task = task.where(['name LIKE ?', "%#{self.q}%"]) if self.q.present?
    task = task.page(self.page).per(PER_PAGE)
    task = task.order(make_order)

    task = task.where(user_id: self.user_id)

    # TODO: STEP16 bullet の動作確認用
    # コメントインすると、N + 1 のエラーは発生しなくなる
    ### task = task.includes(:user)

    task
  end

  def get_condition
    {
      q: self.q,
      status: self.status
    }
  end

  def sort_order
    order_value = self.order.downcase if self.order.present?
    ORDER.include?(order_value) ? order_value : 'desc'
  end

  def sort_column
    sort_value = self.sort.downcase if self.sort.present?
    SORT.include?(sort_value) ? sort_value : 'created_at'
  end

  protected
  attr_accessor :filtered_params, :q, :status, :sort, :order, :page, :user_id

  private
  def make_order
    "#{sort_column} #{sort_order}"
  end
end
