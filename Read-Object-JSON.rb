require('json')
require('date')
require('./order_form')

class ReadObjectJSON
  attr_reader :order_form

  def initialize
    pulled_data = get_order_data
    @order_form ||= OrderForm.new(pulled_data)
  end

  def file
    File.read('temp.json')
  end

  def get_order_data
    JSON.parse(file)
  end

  def write_to_file(order_data)
    File.open('temp.json', 'w') do |f|
      f.write(order_form.order_data.to_json)
    end
  end

  def prompt
    gets.chomp
  end
end

read_order_form = ReadObjectJSON.new
puts read_order_form.order_form.get_due_by_store
puts 'What should be updated? Input quit to complete updates'
user_input = read_order_form.prompt
if user_input == 'quit'
  puts read_order_form.order_form.get_due_by_store
else
  puts user_input
  puts read_order_form.order_form.update_purchase_date(user_input)
  #puts read_order_form.order_form.get_due_by_store
end
puts read_order_form.order_form.get_due_by_store
read_order_form.write_to_file(read_order_form.order_form.order_data)
#allow changes to be made to the hash
#allow the changed has to be written

