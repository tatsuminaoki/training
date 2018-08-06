# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :content, length: { maximum: 200 }

  enum status: %i[to_do doing done]
  enum priority: %i[low middle high]

  validates :status, inclusion: { in: self.statuses.keys }
  validates :priority, inclusion: { in: self.priorities.keys }

  # ページネーションの1ページ毎の表示数のデフォルトを変更
  paginates_per 10

  belongs_to :user

  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  def self.add_search_and_order_condition(tasks, params)
    search_name = params[:search_name]
    search_status = params[:search_status]
    search_label = params[:search_label]
    tasks = tasks.where('tasks.name LIKE ?', "%#{search_name}%") if search_name.present?
    tasks = tasks.where(status: search_status) if search_status.present?
    tasks = tasks.includes(:task_labels).joins(:labels).where('labels.name LIKE ?', "#{search_label}") if search_label.present?
    if params.key?(:sort_category)
      tasks.order(params[:sort_category].to_sym => params[:sort_direction].to_sym, created_at: :desc)
    else
      tasks.order(created_at: :desc)
    end
  end

  def save_labels(labels)
    current_labels = self.labels.pluck(:name) unless self.labels.nil?
    (current_labels - labels).each do |old_name|
      label_id = Label.find_by(name: old_name).id
      if TaskLabel.where(label_id: label_id).count <= 1
        self.labels.find_by(name: old_name).destroy
      else
        TaskLabel.where(task_id: self.id).delete_all
      end
    end
    (labels - current_labels).each do |new_name|
      task_label = Label.find_or_create_by(name: new_name)
      self.labels << task_label
    end
  rescue StandardError
    errors[:base] << I18n.t('errors.messages.label_long')
    raise
  end
end
