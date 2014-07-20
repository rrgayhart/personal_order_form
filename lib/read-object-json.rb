require_relative('engine')

class ReadObjectJSON
  attr_reader :order_form

  def initialize
    pulled_data = get_order_data
    @order_form ||= OrderForm.new(pulled_data)
  end

  def file
    File.read('../db/temp.json')
  end

  def get_order_data
    JSON.parse(file)
  end

  def write_to_file(order_data)
    File.open('../db/temp.json', 'w') do |f|
      f.write(order_form.order_data.to_json)
    end
  end
end
