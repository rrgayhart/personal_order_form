require_relative('lib/engine')

class Run
  attr_reader :input, :output, :engine

  def initialize(input = $stdin, output = $stdout)
    @input = input
    @output = output
    @engine = Engine.new('development')
    run('init')
  end

  def commands
    [
     ['purchased ITEM NAME', 'Mark items as purchased'],
     ['quit', 'Exit without Saving'],
     ['save', 'Save changes and exit'],
     ['due', 'See all upcoming and due items'],
     ['all', 'See all items'],
     ['new', 'Add a new item']
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
      full_prompt
    when /^purchased(.*)$/
      answer = $1.strip
      mark_purchased(answer)
      prompt
    when 'due'
      see_all_due
      prompt
    when 'all'
      see_all
      prompt
    when 'new'
      get_new_item
      prompt
    when 'save'
      save_and_quit
    when 'quit'
      output.puts 'Goodbye'
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
    locations = input.gets.chomp.split(', ')
    unformatted_new_item = {'name' => name,
                'frequency' => freq,
                'lastPurchase' => date,
                'locations' => locations
               }
    if engine.is_valid_item?(unformatted_new_item)
      confirm_new_item(unformatted_new_item)
    else
      output.puts 'Your item was inputed incorrectly'
    end
  end

  def confirm_new_item(unformatted_new_item)
    output.puts engine.print_one_item(unformatted_new_item)
    output.puts 'Is this item correct? Enter yes or no.'
    confirmation = input.gets.chomp
    if confirmation == 'yes'
      engine.add_new_item(unformatted_new_item)
    elsif confirmation == 'no'
      output.puts 'Let\'s start over'
      run('new')
    end
  end

  def see_all_due
    output.puts engine.start_print
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

  def save_and_quit
    engine.save
  end
end

r = Run.new

