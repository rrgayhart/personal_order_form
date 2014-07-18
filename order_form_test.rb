require 'minitest/autorun'
require_relative 'order_form'

class OrderFormTest < MiniTest::Unit::TestCase

  def setup
    @sample_data = [{"name"=>"toilet paper", "frequency"=>"3 months", "locations"=>["costco", "safeway"], "lastPurchase"=>"4/15/2014", "monthsTillDue"=>0},
    {"name"=>"tooth paste", "frequency"=>"4 months", "locations"=>["amazon", "costco", "safeway"], "lastPurchase"=>"4/15/2014", "monthsTillDue"=>1},
    {"name"=>"shaving cream", "frequency"=>"3 months", "locations"=>["amazon"], "lastPurchase"=>"4/15/2014", "searchTerm"=>"Coochy-Original Rash-Free Shaving Cream, 16oz Original", "monthsTillDue"=>0}]
    @of = OrderForm.new(@sample_data)
  end

  def test_it_has_things
    assert_equal 3, @of.order_data.length
  end

  def test_it_updates_purchase_by_name

  end

end
