require_relative('engine')
require_relative('utility')

class OrderForm
  attr_accessor :order_items

  include Utility

  def initialize(incoming_order_data)
    @order_items = create_order_items(incoming_order_data)
  end

  def create_order_items(order_data)
    order_data.collect do |data|
      OrderItem.new(data)
    end
  end

  def replace_items(original_names, items_hash)
    original_names.each do |name|
      remove(name)
    end
    items_hash.each do |item|
      add_new_item(item)
    end
  end

  def convert_order_items_to_hash
    convert_items_to_hash(order_items)
  end

  def convert_items_to_hash(list)
    list.collect do |item|
      item.convert
    end
  end

  def get_item_hashes_by_name(name)
    items = get_items_by_name(name)
    convert_items_to_hash(items)
  end

  def get_items_by_name(name)
    order_items.select do |d|
      d.name.downcase == name
    end
  end

  def display_by_name(name)
    names_list = get_items_by_name(name)
    full_pretty_print_list(names_list)
  end

  def set_due(name)
    order_items.each do |item|
      if name.downcase == item.name
        item.set_due
      end
    end
  end

  def postpone(name)
    order_items.each do |item|
      if name.downcase == item.name
        item.postpone
      end
    end
  end

  def display_frequency(name)
    get_items_by_name(name).collect do |i|
      i.name + ' | is due every ' + i.combine_frequency
    end
  end

  def set_as_purchased_today(input_name)
    @order_items.each do |item|
      if input_name == item.name
        item.update_item({field: 'last_purchase', field_value: normalize_today})
      end
    end
  end

  def pretty_print_list(list)
    list.collect do |d|
      d.name + ' | ' + d.locations.join(' ')
    end
  end

  def get_due_soon(attrs = nil)
    if attrs
      answer = due_soon(attrs)
    else
      answer = due_or_past_due
    end
    pretty_print_list(answer)
  end

  def due_soon(month)
    order_items.select do |item|
      item.due_in_months(month)
    end
  end

  def due_or_past_due
    order_items.select do |item|
      item.due_soon?
    end
  end

  def full_pretty_print(item)
    response = [item.name, ':', 'bought every', item.combine_frequency, '(', item.last_purchase, ')', 'at']
    response.push(item.locations.join(' or '))
    if item.due_soon?
      response.unshift('* ')
    end
    response.join(' ')
  end

  def full_pretty_print_list(list)
    list.collect do |d|
      full_pretty_print(d)
    end.sort.join("\n")
  end

  def see_all
    full_pretty_print_list(order_items)
  end

  def add_new_item(new_item)
    order_items.push(OrderItem.new(new_item))
  end

  def remove(name)
    updated_list = order_items.reject do |item|
      name == item.name
    end
    @order_items = updated_list
  end
end
