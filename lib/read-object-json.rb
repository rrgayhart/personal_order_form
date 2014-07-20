require_relative('engine')

class ReadObjectJSON
  def self.read_file(file)
    File.read(file)
  end

  def self.get_order_data(file)
    JSON.parse(read_file(file))
  end

  def self.write_to_file(order_data, file)
    File.open(file, 'w') do |f|
      f.write(order_data.to_json)
    end
  end
end
