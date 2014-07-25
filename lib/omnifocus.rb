require 'appscript';include Appscript

class OmniFocus

  def self.write_to_document(data)
    begin
      of = app('Omnifocus')
      dd = of.default_document
      note_data = convert_to_string(data)
      props = {:name => 'Shopping List', :note => note_data}
      dd.make(:new => :inbox_task, :with_properties => props)
    rescue
      puts 'Unable to write to Omnifocus'
      puts 'App not found'
    end
  end

  def self.convert_to_string(data)
    due_array = data.get_due_by_store
    due_array.join(' --- ')
  end
end


