require 'appscript';include Appscript

class OmniFocus

  def self.write_to_document
    of = app('Omnifocus')
    dd = of.default_document
    props = {:name => 'New Task', :note => 'Check out these notes'}
    dd.make(:new => :inbox_task, :with_properties => props)
  end
end

o = OmniFocus.write_to_document
