module TestHelpers
  def fill_in_datetime_select(date, id_prifix)
    select date.strftime('%Y'), from: "#{id_prifix}_1i"
    select date.strftime('%-m月'), from: "#{id_prifix}_2i"
    select date.strftime('%-d'), from: "#{id_prifix}_3i"
    select date.strftime('%H'), from: "#{id_prifix}_4i"
    select date.strftime('%M'), from: "#{id_prifix}_5i"
  end
end