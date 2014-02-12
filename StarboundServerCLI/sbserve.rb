#!/usr/bin/env ruby
# A script that will modify the Starbound Server file
require 'json'
require 'optparse'

options = {}

# Formatting options for JSON output
JSON_OPTS = {
  :indent => '  ',
  :space => ' ',
  :space_before => ' ',
  :object_nl => "\n"
}

# Prints out the current server passwords
def print_pw(pw_list)
  puts "Current passwords:"
  pw_list.each_with_index do |pw, i|
    puts " #{i + 1}. #{pw}"
  end
end

# Prompts the user for a password option
def get_pw_opt
  print "Type 'a' (add), 'd' (del), 'e' (exit): "
  STDIN.gets.chomp.downcase
end

# Get the new password to be added
def get_new_pw
  print "Enter new password: "
  STDIN.gets.chomp
end

# Get the index of the password to be deleted
def get_del_index(max)
  print "Which password to delete? (1-#{max}): "
  num = STDIN.gets.chomp.to_i - 1
end

# Display password sub-menu and handle user input
def password(pw_list)
  loop do
    print_pw(pw_list)
    user_in = get_pw_opt
    break if user_in == 'e' or user_in == 'exit'

    if user_in == 'a' or user_in == 'add'
      pw_list.push(get_new_pw)
    elsif user_in == 'd' or user_in == 'del'
      pw_list.delete_at(get_del_index(pw_list.length))
    else
      puts "ERROR: Invalid input - try again."
    end

    puts ""

  end
  pw_list
end

# Write file
def write_config(filename, data)
  begin
    file = File.open(filename, 'w')
    file.puts JSON.generate(data, JSON_OPTS)
    file.close
  rescue Errno::EACCES => e
    puts "ERROR - #{e.message}"
  end
end

# Parse command options
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: ./sbserve.rb file1 [file2 ...] [options]"

  opts.on('-h', '--help', 'Displays help') do
    puts opts
    exit
  end

  opts.on('-w', '--password', 'Edit password list') do
    options[:password] = true
  end
  
  opts.on('-n', '--name [NAME]', 'View/Set Server Name') do |name|
    options[:name] = name
  end

  opts.on('-p', '--port [PORT]', 'View/Set Server Port') do |port|
    options[:port] = port
  end

  opts.on('-f', '--port_forward ON/OFF', [:on, :off], 'Turn Port Forwarding On/Off') do |port_fwd|
    options[:port_fwd] = true if port_fwd == :on
    options[:port_fwd] = false if port_fwd == :off
  end
end
optparse.parse!

# Handle command options on selected server files
ARGV.each do |filename|

  # Load file
  begin
    file = File.open(filename, 'r')
    data = JSON.parse(file.read)
    file.close
  rescue Errno::ENOENT => e
    puts "ERROR - #{e.message}"
    next
  end

  changed = false

  # Process options

  if options.has_key?(:password)
    data["serverPasswords"] = password(data["serverPasswords"])
    changed = true
  end
  
  if options.has_key?(:name)
    if options[:name].nil?
      puts "The server's name is: #{data["serverName"]}."
    else
      data["serverName"] = options[:name]
      puts "The server's name has been set to \"#{data["serverName"]}.\""
      changed = true
    end
  end

  if options.has_key?(:port)
    if options[:port].nil?
      puts "The server's port is: #{data["gamePort"]}."
    else
      data["gamePort"] = options[:port]
      puts "The server's port has been set to: #{data["gamePort"]}."
      changed = true
    end
  end

  if options.has_key?(:port_fwd)
    data["upnpPortForwarding"] = options[:port_fwd]
    puts "Port forwarding has been turned #{data["upnpPortForwarding"] ? "on" : "off"}."
    changed = true
  end

  # Write file
  write_config(filename, data) if changed
end
