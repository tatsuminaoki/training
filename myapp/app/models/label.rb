# frozen_string_literal: true

class Label < ApplicationRecord
  GREEN  = '#79BA5E'.freeze
  YELLOW = '#EED648'.freeze
  ORANGE = '#F2A340'.freeze
  RED =  '#DB634F'.freeze
  PURPLE = '#B87DDA'.freeze
  BLUE = '#3278BA'.freeze

  DEFAULT_COLOR = [GREEN, YELLOW, ORANGE, RED, PURPLE, BLUE]

  belongs_to :project
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels

  validates :color, presence: true

  def self.create_default_label(id)
    recorder = []
    DEFAULT_COLOR.each do |color|
      recorder << { color: name, project_id: id, created_at: DateTime.current, updated_at: DateTime.current }
    end
    Label.insert_all!(recorder)
  end
end
