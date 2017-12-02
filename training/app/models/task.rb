class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }

  def self.create_task(params)
    create(name: params[:name],
           description: params[:description]
          )
  end
end
