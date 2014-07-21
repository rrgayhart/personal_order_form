require 'minitest/autorun'
require_relative '../lib/engine'

class OrderFormTest < MiniTest::Unit::TestCase

  def setup
    @today = Date.today.strftime('%m/%d/%Y')
    @four_months_ago = Date.today.prev_month.prev_month.prev_month.prev_month.strftime('%m/%d/%Y')
    @sample_data = [{"name"=>"toilet paper", "frequency"=>"4 months", "locations"=>["costco", "safeway"], "lastPurchase"=>@four_months_ago},
    {"name"=>"tooth paste", "frequency"=>"4 months", "locations"=>["amazon", "costco", "safeway"], "lastPurchase"=>@today},
    {"name"=>"shaving cream", "frequency"=>"2 months", "locations"=>["amazon"], "lastPurchase"=>@four_months_ago}]
    @of = OrderForm.new(@sample_data)
  end

  def test_it_has_things
    assert_equal 3, @of.order_data.length
  end

  def test_it_sets_purchased_today
    refute_equal @today, @of.order_data.first['lastPurchase']
    @of.set_as_purchased_today(@of.order_data.first['name'])
    assert_equal @today, @of.order_data.first['lastPurchase']
  end

  def test_it_updates_purchase_by_name
    existing_product = @of.order_data.first['name']
    @of.update_purchase_by_name({name: existing_product, field: 'lastPurchase', field_value: '5/15/2014'})
    assert_equal '5/15/2014', @of.order_data.first['lastPurchase']
  end

  def test_it_does_not_create_nonexistant_name
    assert_equal 3, @of.order_data.length
    not_existing_product = 'BANANA FARMS'
    @of.update_purchase_by_name({name: not_existing_product, field: 'lastPurchase', field_value: '5/15/2014'})
    assert_equal 3, @of.order_data.length
  end

  def test_it_gets_purchase_frequency
    answer = 3
    assert_equal answer, @of.get_frequency('3 months')
  end

  def test_it_gets_months_since_last_purchase
    assert_equal 4, @of.months_since_last_purchase(@four_months_ago)
  end

  def test_it_gets_months_since_last_purchase_over_a_year_ago
    one_year_one_month_ago = Date.today.prev_year.prev_month.strftime('%m/%d/%Y')
    assert_equal 13, @of.months_since_last_purchase(one_year_one_month_ago)
  end

  def test_it_gets_months_until_purchase_due
    assert_equal 0, @of.months_until_purchase(@sample_data[0])
    assert_equal 4, @of.months_until_purchase(@sample_data[1])
    assert_equal -2, @of.months_until_purchase(@sample_data[2])
  end

  def test_it_pulls_due_or_past_due_products
    assert_equal 2, @of.due_or_past_due.length
    assert_includes(@of.due_or_past_due, @sample_data[0])
    assert_includes(@of.due_or_past_due, @sample_data[2])
    refute_includes(@of.due_or_past_due, @sample_data[1])
  end

  def test_pretty_print_list_formats_correctly
    pretty_printed_collection = ["toilet paper | costco safeway", "tooth paste | amazon costco safeway", "shaving cream | amazon"]
    assert_equal pretty_printed_collection, @of.pretty_print_list(@sample_data)
  end

  def test_full_pretty_print_list
    answer = "shaving cream: bought every 2 months ( 03/20/2014 ) at amazon\n" +
    "toilet paper: bought every 4 months ( 03/20/2014 ) at costco or safeway\n" +
    "tooth paste: bought every 4 months ( 07/20/2014 ) at amazon or costco or safeway"
    assert_equal answer, @of.full_pretty_print_list(@sample_data)
  end

  def test_add_new_item_updates
    assert_equal 3, @of.order_data.length
    new_item = {'name' => 'paper towels', 'frequency' => '3 months', 'lastPurchase' => '3', 'locations' => ['costco', 'target'] }
    @of.add_new_item(new_item)
    assert_equal 4, @of.order_data.length
    assert_equal 'paper towels', @of.order_data.last['name']
  end

end
