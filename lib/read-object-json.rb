require_relative('engine')
require('date')

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

  def self.write_to_backup(order_data)
    begin
      file_name = "#{Date.today.strftime('%d%m')}backup.txt"
      path = "./db/backups/" + file_name
      File.open(path, "a+") do |f|
        data = [Time.now.to_s, order_data.to_json, ("_" * 40), "\n"].join("\n")
        f << data
      end
    rescue
      puts 'Back-ups are not functioning'
    end
  end
end
