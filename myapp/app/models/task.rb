class Task < ApplicationRecord
  enum priority: {Low: 0, Middle: 1, High: 2}
  enum status: {Open: 0, InProgress: 1, Closed: 2}

  belongs_to :user

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
  end
  scope :title_like, -> (title) { where('title LIKE ?', "%#{title}%") if title.present? }
  scope :status_is, -> (status) { where(status: status) if status.present? }
end
