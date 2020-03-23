# frozen_string_literal: true

class Label < ApplicationRecord
  belongs_to :project
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels

  GREEN  = '#79BA5E'
  YELLOW = '#EED648'
  ORANGE = '#F2A340'
  RED = '#DB634F'
  PURPLE = '#B87DDA'
  BLUE = '#3278BA'

  DEFAULT_COLOR = [GREEN, YELLOW, ORANGE, RED, PURPLE, BLUE].freeze
  def self.create_default_label(id)
    DEFAULT_COLOR.each do |color|
      Label.new(color: color, project_id: id).save
    end
  end
end
