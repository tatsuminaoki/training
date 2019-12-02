class Task < ApplicationRecord
  enum priority: {Low: 0, Middle: 1, High: 2}
  enum status: {Open: 0, InProgress: 1, Closed: 2}

  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

  TITLE_MAX_LENGTH = 255
  DESCRIPTION_MAX_LENGTH = 512

  validates :title,
    presence: true,
    length: { maximum: TITLE_MAX_LENGTH }

  validates :description,
    length: { maximum: DESCRIPTION_MAX_LENGTH }

  validates :priority,
    presence: true

  validates :status,
    presence: true

  scope :search, -> (search_params) do
    return if search_params.blank?

    title_like(search_params[:title])
      .status_is(search_params[:status])
      .from_label(search_params[:label])
  end
  scope :title_like, -> (title) { where('title LIKE ?', "%#{title}%") if title.present? }
  scope :status_is, -> (status) { where(status: status) if status.present? }
  scope :from_label, -> (label_name) {
    return if label_name.empty?
    label_id = Label.where('name LIKE ?', "%#{label_name}%").select(:id)
    where(id: task_ids = TaskLabel.where(label_id: label_id).select(:task_id))
  }

  def save_labels(labels)
    current_labels = self.labels.pluck(:name) unless self.labels.nil?
    old_labels = current_labels - labels
    new_labels = labels - current_labels

    # destroy old labels
    old_labels.each do |old_name|
      self.labels.delete Label.find_by(name: old_name)
    end

    # create new labels
    new_labels.each do |new_name|
      task_label = Label.find_or_create_by(name: new_name)
      if task_label.invalid?
        return false
      else
        self.labels << task_label
      end
    end
  end
end
