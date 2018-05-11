class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: TITLE_MAXIMUM_LENGTH = 20 }
  validates :user_id, presence: true
  validates :description, presence: true, length: { maximum: DESCRIPTION_MAXIMUM_LENGTH = 400 }
  validates :status, presence: true
  validates :priority, presence: true

  has_many :task_to_labels, dependent: :destroy
  has_many :labels, through: :task_to_labels

  belongs_to :user

  after_save :add_labels

  scope :get_by_user_id, ->(user_id) {
    where(user_id: user_id)
  }

  scope :get_by_status, ->(status) {
    where(status: status)
  }

  scope :get_by_keyword, ->(keyword) {
    where('title like :keyword', keyword: "%#{keyword}%")
      .or(where('description like :keyword', keyword: "%#{keyword}%"))
  }

  def set_labels(labels, new_labels)
    @labels = labels
    @new_labels = new_labels
  end

  private
    def add_labels
      TaskToLabel.where(task_id: id).delete_all

      if @labels.present?
        @labels.each do |label|
          TaskToLabel.create( task_id: id, label_id: label.to_i )
        end
      end

      if @new_labels.present?
        @new_labels.each do |new_label|
          label = Label.create(label: new_label, user_id: user_id)
          TaskToLabel.create( task_id: id, label_id: label.id )
        end
      end
    end
end
