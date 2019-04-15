class SearchTask
  include ActiveModel::Model

  PER_PAGE = 10

  SORT = [
    "expire_date"
  ]

  ORDER = [
    "asc", "desc"
  ]

  def initialize(params)
    self.filtered_params = params.permit(
      :q, :status, :sort, :order, :page
    )

    self.q = self.filtered_params[:q] if self.filtered_params[:q].present?
    self.status = self.filtered_params[:status] if self.filtered_params[:status].present?
    self.sort = self.filtered_params[:sort] if self.filtered_params[:sort].present?
    self.order = self.filtered_params[:order] if self.filtered_params[:order].present?
    self.page = self.filtered_params[:page] if self.filtered_params[:page].present?
  end

  def execute
    task = Task.all
    task = task.where(status: self.filtered_params[:status]) if self.filtered_params[:status].present?
    task = task.where(['name LIKE ?', "%#{self.filtered_params[:q]}%"]) if self.filtered_params[:q].present?
    task = task.page(self.filtered_params[:page]).per(PER_PAGE)
    task = task.order(make_order)

    task
  end

  def get_condition
    {
      q: self.q,
      status: self.status
    }
  end

  def sort_order
    order_value = self.filtered_params[:order].downcase if self.filtered_params[:order].present?
    ORDER.include?(order_value) ? order_value : "desc"
  end

  def sort_column
    sort_value = self.filtered_params[:sort].downcase if self.filtered_params[:sort].present?
    SORT.include?(sort_value) ? sort_value : "created_at"
  end

  protected
  attr_accessor :filtered_params, :q, :status, :sort, :order, :page

  private
  def make_order
    "#{sort_column} #{sort_order}"
  end
end
