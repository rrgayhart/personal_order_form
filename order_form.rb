require('date')

class OrderForm
  attr_accessor :order_data

  def initialize(incoming_order_data)
    @order_data ||= incoming_order_data
  end

  def normalize_today
    today = Date.today
    today.strftime('%m/%d/%Y')
  end

  def update_purchase_by_name(input_name)
    updates = order_data.each do |d|
      if d['name'] == input_name
        d['lastPurchase'] = normalize_today
      end
    end
    @order_data = updates
  end

  def get_frequency(freq_date)
    freq_date.scan(/\d+/).first.to_i
  end

  def months_since_last_purchase(purch_date)
    date = Date.strptime(purch_date, '%m/%d/%Y')
    year_difference = (Date.today.year - date.year) * 12
    month_difference = Date.today.month - date.month
    year_difference + month_difference
  end

  def get_months_until_purchase(purchase)
    purch_date = purchase['lastPurchase']
    freq_date = purchase['frequency']
    get_frequency(freq_date) - months_since_last_purchase(purch_date)
  end

  def due_or_past_due
    answer = []
    order_data.each do |d|
      d['monthsTillDue'] = get_months_until_purchase(d)
      if d['monthsTillDue'] < 1
        answer.push(d)
      end
    end
    answer
  end

  def pretty_print_list(list)
    list.collect do |d|
      d['name'] + ' | ' + d['locations'].join(' ')
    end
  end

  def get_due_by_store(attrs = nil)
    if attrs
      answer = due_or_past_due.select do |d|
        d['locations'].join(' ').downcase.include?(attrs.downcase)
      end
    else
      answer = due_or_past_due
    end
    pretty_print_list(answer)
  end

  def update_purchase_date(item_name)
    update_purchase_by_name(item_name)
  end
end
