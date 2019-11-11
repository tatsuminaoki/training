class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  enum status: [ :todo, :processing, :done ]

  def status_ja
    Task.human_attribute_name("status.#{self.status}")
  end

  def self.statuses_ja
    Task.statuses.map {|k,v| [Task.human_attribute_name("status.#{k}"),v]}.to_h
  end

  def self.find_with_conditions(params)
    sql = " 1 = 1 "
    args = []
    params.each do |k,v|
      if k == 'status' and v.present?
        sql += " AND status = ? "
        args.push v
      end

      if k == 'name' and v.present?
        sql += " AND name like ? "
        args.push "%" + v + "%"
      end
    end

    Task.where(sql, *args)
  end
end
