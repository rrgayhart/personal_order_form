require 'minitest/autorun'
require_relative '../lib/engine'

class OrderItemTest < MiniTest::Unit::TestCase

  def setup
    @today = Date.today.strftime('%m/%d/%Y')
    @four_months_ago = Date.today.prev_month.prev_month.prev_month.prev_month.strftime('%m/%d/%Y')
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
    assert_equal @today, @oi.last_purchase
  end

  def test_it_creates_locations_correctly
    assert_equal ["amazon", "costco"], @oi.locations
  end

  def test_it_gets_months_since_last_purchase
    assert_equal 4, @oi.months_since_last_purchase(@four_months_ago)
  end

  def test_it_gets_months_since_last_purchase_over_a_year_ago
    one_year_one_month_ago = Date.today.prev_year.prev_month.strftime('%m/%d/%Y')
    assert_equal 13, @oi.months_since_last_purchase(one_year_one_month_ago)
  end

  def test_it_gets_zero_months_until_purchase
    zero_data = {"name"=>"toilet paper", "frequency"=>"4 months", "locations"=>["costco", "safeway"], "lastPurchase"=>@four_months_ago}
    zero_item = OrderItem.new(zero_data)
    assert_equal 0, zero_item.months_until_purchase
  end

  def test_it_gets_positive_months_until_purchase
    positive_data = {"name"=>"tooth paste", "frequency"=>"4 months", "locations"=>["amazon", "costco", "safeway"], "lastPurchase"=>@today}
    positive_item = OrderItem.new(positive_data)
    assert_equal 4, positive_item.months_until_purchase
  end

  def test_it_gets_negative_months_until_purchase
    negative_data = {"name"=>"shaving cream", "frequency"=>"2 months", "locations"=>["amazon"], "lastPurchase"=>@four_months_ago}
    negative_item = OrderItem.new(negative_data)
    assert_equal -2, negative_item.months_until_purchase
  end
end
