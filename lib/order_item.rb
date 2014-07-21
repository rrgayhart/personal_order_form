require_relative('engine')
require_relative('utility')

class OrderItem

  attr_reader :item_hash, :name, :freq_count, :freq_type, :last_purchased, :locations

  def initialize(item_hash)
    @item_hash = item_hash
    @name = get_name
    @freq_count = parse_frequency[0]
    @freq_type = parse_frequency[1]
    @last_purchased = parse_purchased_date
    @locations = get_locations
  end

  def get_name
    item_hash['name']
  end

  def parse_frequency
    split = item_hash['frequency'].split(' ')
    [split[0].to_i, split[1]]
  end

  def order_keys
    ['name', 'frequency', 'locations', 'lastPurchased']
  end

  def parse_purchased_date
    item_hash['lastPurchase']
  end

  def get_locations
    item_hash['locations']
  end

end
