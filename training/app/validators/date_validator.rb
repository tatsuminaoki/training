class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true if value.blank? || value.instance_of?(Date)
    unless date_valid?(value)
      record.errors[attribute] << (options[:message] || ": 設定が不正")
    end
  end

  private

  def date_valid?(str)
    !! Date.parse(str) rescue false
  end
end