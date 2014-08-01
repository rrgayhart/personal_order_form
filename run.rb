require_relative('lib/engine')

class Run
  attr_accessor :input, :output, :engine, :environ

  def initialize(environ, input = $stdin, output = $stdout)
    @input = input
    @output = output
    @environ = environ
    @engine = Engine.new(environ)
  end

  def commands
    [
     ['purchased ITEM NAME', 'Mark items as purchased'],
     ['quit', 'Exit without Saving'],
     ['save', 'Save changes and exit'],
     ['due', 'See all upcoming and due items'],
     ['due next', 'See all items due next month'],
     ['all', 'See all items'],
     ['new', 'Add a new item'],
     ['show ITEM NAME', 'Show item'],
     ['delete ITEM NAME', 'Delete item by name'],
     ['edit ITEM NAME', 'Edit item by name'],
     ['postpone ITEM NAME', 'Increase monthly purchase frequency'],
     ['set due ITEM NAME', 'Set item as due this month'],
     ['make list', 'Adds an omnifocus task']
    ]
  end

  def full_prompt
    output.puts "COMMANDS\n"
    joined_commands = commands.collect { |c| c.join(' - ') }
    output.puts joined_commands.join("\n")
    output.puts 'Select a Command:'
    user_input = input.gets.chomp
    run(user_input)
  end

  def prompt
    output.puts '-' * 10
    output.puts commands.collect{ |c| c[0] }.join(' - ')
    output.puts '-' * 10
    output.puts 'Select a command:'
    user_input = input.gets.chomp
    run(user_input)
  end

  def run(user_input)
    case user_input.downcase
    when 'init'
      if environ == 'production'
        run_backup
      end
      full_prompt
    when /^purchased(.*)$/
      answer = $1.strip
      mark_purchased(answer)
      prompt
    when 'due'
      see_all_due
      prompt
    when 'due next'
      see_due_next_month
      prompt
    when 'all'
      see_all
      prompt
    when 'new'
      get_new_item
      prompt
    when /^delete(.*)$/
      name = $1.strip
      confirm_delete(name)
      prompt
    when /^edit(.*)$/
      name = $1.strip
      begin_edit(name)
      prompt
    when /^show(.*)$/
      name = $1.strip
      begin_show(name)
      prompt
    when /^postpone(.*)$/
      name = $1.strip
      postpone(name)
      prompt
    when /^set due(.*)$/
      name = $1.strip
      set_due(name)
      prompt
    when 'make list'
      write_to_omnifocus
      prompt
    when 'save'
      confirm_save
      prompt
    when 'quit'
      output.puts 'Goodbye'
    else
      output.puts 'Command ' + user_input + 'not recognized.'
      prompt
    end
  end

  def run_backup
    ReadObjectJSON.write_to_backup(engine.order_form.convert_order_items_to_hash)
  end

  def set_due(name)
    output.puts engine.set_due(name)
  end

  def postpone(name)
    output.puts engine.postpone(name)
  end

  def begin_show(name)
    output.puts engine.display_item_fuzzy(name)
  end

  def begin_edit(name)
    item_data = engine.pull_hash_by_name(name)
    if item_data.any?
      display_item(name)
      edit_per_field(item_data)
    else
      output.puts 'Nothing was found by the name ' + name
    end
  end

  def display_item(name)
    output.puts engine.display_by_name(name)
  end

  def edit_per_field(item_data)
    output.puts "#{item_data.length} items found."
    output.puts 'Hit enter to keep existing data'
    output.puts 'Or input different information and then hit enter to change'
    new_item_data = []
    item_data.each do |item|
      new_item = {'original_name' => item['name']}
      item.each do |k, v|
        output.puts k + ' : ' + v.to_s
        change = input.gets.chomp
        if change.length > 2
          new_item[k] = change
        else
          new_item[k] = v
        end
      end
      new_item_data.push(new_item)
    end
    confirm_edit(new_item_data)
  end

  def confirm_edit(new_item_data)
    output.puts 'The following changes will be added:'
    original_names = new_item_data.collect {|i| i.delete('original_name')}
    new_item_data.each do |item|
      output.puts engine.print_one_hash(item)
    end
    output.puts '-' * 20
    output.puts 'Please confirm these changes. (yes, no)'
      confirmation = input.gets.chomp
    if confirmation == 'yes'
      engine.replace_items(original_names, new_item_data)
    end
  end

  def write_to_omnifocus
    puts 'Sending a list of all upcoming due purchases to Omnifocus'
    engine.write_to_omnifocus
  end

  def confirm_save
    see_all
    output.puts '-' * 20
    output.puts 'Confirm save of all changes to db: (yes/no)'
    confirmation = input.gets.chomp
    if confirmation == 'yes'
      save_to_file
    end
  end

  def confirm_delete(name)
    output.puts 'Confirm delete of the following items: (yes/no)'
    items_for_delete = engine.display_by_name(name)
    output.puts items_for_delete
    confirmation = input.gets.chomp
    if confirmation == 'yes'
      delete_by_name(name)
      output.puts items_for_delete + ' has been removed'
    end
  end

  def get_new_item
    output.puts 'Enter the name of the new item'
    name = input.gets.chomp
    output.puts 'enter frequency in months that this item is due'
    freq = input.gets.chomp + ' months'
    output.puts 'enter the date that ' + name + ' was last purchased.'
    output.puts 'Make sure it is in Month/Day/Year (01/06/2014) formatting'
    date = input.gets.chomp
    output.puts 'Enter a list of locations where item is purchased'
    output.puts 'Seperated by commas'
    locations = input.gets.chomp
    unformatted_new_item = {'name' => name,
                'frequency' => freq,
                'lastPurchase' => date,
                'locations' => locations
               }
    confirm_new_item(unformatted_new_item)
  end

  def confirm_new_item(unformatted_new_item)
    output.puts engine.print_one_hash(unformatted_new_item)
    output.puts 'Is this item correct? Enter yes or no.'
    confirmation = input.gets.chomp
    if confirmation == 'yes'
      engine.add_new_item(unformatted_new_item)
    elsif confirmation == 'no'
      output.puts 'Let\'s start over'
    end
  end

  def delete_by_name(name)
    output.puts name
    engine.delete(name)
  end

  def see_all_due
    output.puts engine.start_print
  end

  def see_due_next_month
    output.puts engine.see_due_next_month
  end

  def see_all
    output.puts engine.see_all
  end

  def mark_purchased(user_input_name)
    output.puts engine.display_by_name(user_input_name)
    output.puts "Input 'yes' to update and 'no' to cancel"
    user_input = input.gets.chomp
    if user_input == 'yes'
      engine.update_by_name(user_input_name)
    end
  end

  def save_to_file
    engine.save
  end
end
