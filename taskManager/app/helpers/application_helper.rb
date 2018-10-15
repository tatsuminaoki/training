module ApplicationHelper
  def date_format(date, year: true)
    date_string = ""
    if date.nil? then
      date_string += "-"
    else
      date_string += date.strftime('%Y/') if year
      date_string += date.strftime("%m/%d(#{%w(日 月 火 水 木 金 土)[date.wday]})")
    end

    %(#{date_string}).html_safe
  end
end
