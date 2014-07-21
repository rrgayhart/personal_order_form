require 'minitest/autorun'
require_relative '../lib/engine'

class OrderItemTest < MiniTest::Unit::TestCase

  def setup
    @today = Date.today.strftime('%m/%d/%Y')
    @item_hash = {"name"=>"tooth paste", "frequency"=>"4 months", "locations"=>["amazon", "costco"], "lastPurchase"=>@today}
    @oi = OrderItem.new(@item_hash)
  end

  def test_it_creates_an_order_item_from_hash
    assert_equal 'tooth paste', @oi.name
  end

  def test_it_converts_frequency_correctly
    assert_equal 4, @oi.freq_count
    assert_equal 'months', @oi.freq_type
  end

  def test_it_converts_dates_correctly
    assert_equal @today, @oi.last_purchased
  end

  def test_it_creates_locations_correctly
    assert_equal ["amazon", "costco"], @oi.locations
  end

end
