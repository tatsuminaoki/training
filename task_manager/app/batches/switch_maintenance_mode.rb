# frozen_string_literal: true

class SwitchMaintenanceMode
  def exec
    exist_503_file? ? rm_503_file : cp_503_file
  end

  def exist_503_file?
    File.exist?("#{Rails.public_path}/tmp/503.html")
  end

  def cp_503_file
    FileUtils.cp "#{Rails.public_path}/503.html", "#{Rails.public_path}/tmp/503.html"
  end

  def rm_503_file
    FileUtils.rm "#{Rails.public_path}/tmp/503.html"
  end
end
