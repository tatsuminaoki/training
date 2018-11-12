# frozen_string_literal: true

module TestHelpers
  def add_label(id, labels)
    labels.each do |label|
      page.execute_script("$('#{id}').tagit('createTag', '#{label}')")
    end
  end

  def delete_label(id, labels)
    labels.each do |label|
      page.execute_script("$('#{id}').tagit('removeTagByLabel', '#{label}')")
    end
  end
end
