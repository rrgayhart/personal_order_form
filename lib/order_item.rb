require_relative('engine')
require_relative('utility')

class OrderItem

  attr_accessor :item_hash, :name, :freq_count, :freq_type, :last_purchase, :locations

  include Utility

  def initialize(item_hash)
    @item_hash = item_hash
    @name = get_name
    @freq_count = parse_frequency[0]
    @freq_type = parse_frequency[1]
    @last_purchase = parse_purchased_date
    @locations = get_locations
  end

  def get_name
    item_hash['name']
  end

  def parse_frequency
    split = item_hash['frequency'].split(' ')
    [split[0].to_i, split[1]]
  end

  def convert
    {'name' => self.name,
     'frequency' => combine_frequency,
     'locations' => self.locations,
     'lastPurchase' => self.last_purchase
    }
  end

  def combine_frequency
    [self.freq_count, ' ', self.freq_type].join
  end

  def parse_purchased_date
    item_hash['lastPurchase']
  end

  def get_locations
    l = item_hash['locations']
    if l.class == String
      l.split(', ')
    else
      l
    end
  end

  def update_item(attrs)
    case attrs[:field]
    when 'last_purchase'
      self.last_purchase = attrs[:field_value]
    end
  end

  def months_since_last_purchase(purch_date)
    year_difference = (Date.today.year - convert_date(purch_date).year) * 12
    month_difference = Date.today.month - convert_date(purch_date).month
    year_difference + month_difference
  end

  def months_until_purchase
    purch_date = self.last_purchase
    self.freq_count - months_since_last_purchase(purch_date)
  end

end
