require('json')
require('date')
require_relative('./order_form')
require_relative('./read-object-json')

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

  def start_print
    order_form.get_due_by_store
  end

  def display_by_name(name)
    order_form.display_by_name(name)
  end

  def update_by_name(name)
    order_form.set_as_purchased_today(name)
  end

  def save
    ReadObjectJSON.write_to_file(order_form.order_data, file_name)
  end
end

