class ApplicationRecord < ActiveRecord::Base   
  self.abstract_class = true

  def human_enum_name param
    self.class.human_attribute_name("#{param}.#{self[param]}")
  end
  
  def self.human_enum_list param
    self.send("#{param}".pluralize).keys.collect { |key| [I18n.t("activerecord.attributes.task/#{param}.#{key.downcase}"), key] }
  end
end
