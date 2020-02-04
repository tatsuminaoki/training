class LogicMaintenance
  def self.is_doing
    maintenance = Maintenance.first;
    return false if maintenance.nil?
    now = Time.now
    maintenance.start_at <= now && maintenance.end_at >= now
  end

  def self.register(start_str, end_str)
    begin
      start_at = Time.parse(start_str)
      end_at   = Time.parse(end_str)
    rescue ArgumentError
      return false
    end

    maintenance = Maintenance.first;
    if maintenance.nil?
      maintenance = Maintenance.new(
        start_at: start_at,
        end_at:   end_at,
      )
    else
      maintenance.start_at = start_at
      maintenance.end_at = end_at
    end
    return false unless maintenance.valid?
    return maintenance.save
  end
end
