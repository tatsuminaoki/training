Rails.application.config.action_view.field_error_proc = Proc.new do |html_tag, instance|
  %Q(#{html_tag}).html_safe
end
