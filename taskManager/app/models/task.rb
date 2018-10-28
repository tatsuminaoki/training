class Task < ApplicationRecord
  belongs_to :user
  has_many :task_label, dependent: :destroy
  accepts_nested_attributes_for :task_label

  enum status: {
    waiting: 0, working: 1, completed: 2
  }
  enum priority: {
    low: 0, common: 1, high: 2
  }

  validates :task_name,
            presence: true,
            length: { maximum: 255 }

  validates :description,
            presence: true,
            length: { maximum: 20_000 }

  validates :user_id, presence: true

  validates :priority,
            presence: true,
            inclusion: { in: Task.priorities.keys }

  validates :status,
            presence: true,
            inclusion: { in: Task.statuses.keys }

  # TODO: STEP12の課題で作ったもの
  default_scope -> { order(Arel.sql("deadline is null, deadline asc, created_at desc")) }

  def self.search(params)
    results = Task.all
    results = results.where(status: params[:status]) if params[:status].present?

    if params[:task_name].present?
      search_word = replace_search_word(search_word: params[:task_name].dup)
      results = results.where("task_name like ?", "%#{search_word}%")
    end
    results
  end

  private

  def self.replace_search_word(search_word:)
    search_word.gsub!(/\%/, "\\%")
    search_word.gsub!(/\_/, "\\_")
    return search_word
  end
end
