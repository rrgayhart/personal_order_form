require('json')
require('date')
require_relative('./order_form')
require_relative('./order_item')
require_relative('./read-object-json')
require_relative('./omnifocus')

class Engine
  attr_accessor :order_form, :file_name

  def initialize(input)
    @file_name = select_file(input)
    data = ReadObjectJSON.get_order_data(file_name)
    @order_form ||= OrderForm.new(data)
  end

  def select_file(input)
    if input === 'test'
      './test/test.json'
    elsif input === 'production'
      './db/production.json'
    else
      './db/temp.json'
    end
  end

  def write_to_omnifocus
    OmniFocus.write_to_document(order_form)
  end

  def start_print
    order_form.get_due_soon
  end

  def see_due_next_month
    order_form.get_due_soon(1)
  end

  def print_one_hash(hash)
    oi = OrderItem.new(hash)
    print_one_item(oi)
  end

  def pull_hash_by_name(name)
    order_form.get_item_hashes_by_name(name)
  end

  def print_one_item(item)
    order_form.full_pretty_print(item)
  end

  def display_by_name(name)
    order_form.display_by_name(name)
  end

  def display_item_fuzzy(name)
    order_form.display_item_fuzzy(name)
  end

  def update_by_name(name)
    order_form.set_as_purchased_today(name)
  end

  def replace_items(original_names, item_hash)
    order_form.replace_items(original_names, item_hash)
  end

  def add_new_item(new_item)
    order_form.add_new_item(new_item)
  end

  def postpone(name)
    order_form.postpone(name)
    order_form.display_frequency(name)
  end

  def set_due(name)
    order_form.set_due(name)
    order_form.display_frequency(name)
  end

  def see_all
    order_form.see_all
  end

  def delete(name)
    order_form.remove(name)
  end

  def save
    items_hash = order_form.convert_order_items_to_hash
    ReadObjectJSON.write_to_file(items_hash, file_name)
  end
end

