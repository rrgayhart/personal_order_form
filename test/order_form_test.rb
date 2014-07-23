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
    assert_equal 3, @of.order_items.length
  end

  def test_it_sets_purchased_today
    refute_equal @today, @of.order_items.first.last_purchase
    @of.set_as_purchased_today(@sample_data.first['name'])
    assert_equal @today, @of.order_items.first.last_purchase
  end

  def test_it_does_not_create_nonexistant_name
    assert_equal 3, @of.order_items.length
    not_existing_product = 'BANANA FARMS'
    @of.set_as_purchased_today(not_existing_product)
    assert_equal 3, @of.order_items.length
  end

  def test_it_pulls_due_or_past_due_products
    assert_equal 2, @of.due_or_past_due.length
    names = @of.due_or_past_due.collect do |item|
      item.name
    end
    assert_includes(names, 'toilet paper')
    assert_includes(names, 'shaving cream')
    refute_includes(names, 'tooth paste')
  end

  def test_add_new_item_updates
    assert_equal 3, @of.order_items.length
    new_item = {'name' => 'paper towels', 'frequency' => '3 months', 'lastPurchase' => '3', 'locations' => ['costco', 'target'] }
    @of.add_new_item(new_item)
    assert_equal 4, @of.order_items.length
    assert_equal 'paper towels', @of.order_items.last.name
  end

  def test_it_creates_order_items
    assert_equal @sample_data.length, @of.order_items.count
    assert_equal OrderItem, @of.order_items.first.class
  end

  def test_it_converts_order_items_to_hash
    assert_equal @sample_data, @of.convert_order_items_to_hash
  end

  def test_delete_items
    assert_equal 3, @of.order_items.length
    @of.remove(@of.order_items.first.name)
    assert_equal 2, @of.order_items.length
  end
end
