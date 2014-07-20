require_relative('lib/engine')

#commands = [['due now', 'See what is due now'], ['mark bought', 'Mark an order as purchased today']]
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
     ['mp', 'Mark items as purchased'],
     ['quit', 'Exit without Saving'],
     ['save', 'Save changes and exit'],
     ['due', 'See all upcoming and due items']
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
    when 'mp'
      mark_purchased_loop
      prompt
    when 'due'
      see_all_due
      prompt
    when 'save'
      save_and_quit
    when 'quit'
      output.puts 'Goodbye'
    end
  end

  def see_all_due
    output.puts engine.start_print
  end

  def mark_purchased_loop
    output.puts "Select a name to mark as purchased"
    user_input_name = input.gets.chomp
    output.puts "Input 'yes' to update and 'no' to cancel"
    output.puts engine.display_by_name(user_input_name)
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

