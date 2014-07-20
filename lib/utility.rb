module Utility
  def normalize_today
    Date.today.strftime('%m/%d/%Y')
  end

  def convert_date(date)
    Date.strptime(date, '%m/%d/%Y')
  end
end
