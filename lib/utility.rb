module Utility
  def normalize_today
    Date.today.strftime('%m/%d/%Y')
  end

  def convert_date(date)
    Date.strptime(date, '%m/%d/%Y')
  end

  def date_to_s(date)
    date.strftime('%m/%d/%Y')
  end
end
