class Label < ApplicationRecord
  belongs_to :project
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels

  GREEN  = '#79BA5E'.freeze
  YELLOW = '#EED648'.freeze
  ORANGE = '#F2A340'.freeze
  RED =  '#DB634F'.freeze
  PURPLE = '#B87DDA'.freeze
  BLUE = '#3278BA'.freeze

  DEFAULT_COLOR = [GREEN, YELLOW, ORANGE, RED, PURPLE, BLUE]
  def self.create_default_label(id)
    DEFAULT_COLOR.each_with_index do |color, index|
      Label.new(color: color, project_id: id).save
    end
  end
end
