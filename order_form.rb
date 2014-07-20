require('./engine')
require_relative('utility')

class OrderForm
  attr_accessor :order_data
  include Utility

  def initialize(incoming_order_data)
    @order_data ||= incoming_order_data
  end

  def update_purchase_by_name(attrs=nil)
    updates = order_data.each do |d|
      if d['name'].downcase == attrs[:name].downcase
        d[attrs[:field]] = attrs[:field_value]
      end
    end
    @order_data = updates
  end

  def set_as_purchased_today(input_name)
    today_update = {name: input_name, field: 'lastPurchase', field_value: normalize_today}
    update_purchase_by_name(today_update)
  end

  def get_frequency(freq_date)
    freq_date.scan(/\d+/).first.to_i
  end

  def months_since_last_purchase(purch_date)
    year_difference = (Date.today.year - convert_date(purch_date).year) * 12
    month_difference = Date.today.month - convert_date(purch_date).month
    year_difference + month_difference
  end

  def months_until_purchase(purchase)
    purch_date = purchase['lastPurchase']
    freq_date = purchase['frequency']
    get_frequency(freq_date) - months_since_last_purchase(purch_date)
  end

  def due_or_past_due
    order_data.select do |d|
      d['monthsTillDue'] < 1
    end
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
