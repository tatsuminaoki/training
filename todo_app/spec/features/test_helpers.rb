# frozen_string_literal: true

module TestHelpers
  def fill_in_datetime_select(date, id_prefix)
    select date.strftime('%Y'), from: "#{id_prefix}_1i"
    select date.strftime('%-m月'), from: "#{id_prefix}_2i"
    select date.strftime('%-d'), from: "#{id_prefix}_3i"
    select date.strftime('%H'), from: "#{id_prefix}_4i"
    select date.strftime('%M'), from: "#{id_prefix}_5i"
  end
end
