#!/usr/bin/env ruby
# A script that will modify the Starbound Server file
# Author: Tim Schofield
require 'json'
require 'optparse'

#############
# Constants #
#############

# Formatting options for JSON output
JSON_OPTS = {
  :indent => '  ',
  :space => ' ',
  :space_before => ' ',
  :object_nl => "\n"
}

###########
# Classes #
###########

class Password_List
  attr_reader :pw_list

  def initialize(pw_list)
    @pw_list = pw_list
  end

  # Prints out the current server passwords
  def print_list
    puts "Current passwords:"
    @pw_list.each_with_index do |pw, i|
      puts " #{i + 1}. #{pw}"
    end
  end

  # Add a new password to the list
  def add
    print "Enter new password: "
    pw = STDIN.gets.chomp
    @pw_list.push(pw) unless @pw_list.include?(pw)
  end

  # Delete a password in the list
  def delete
    print "Which password to delete? (1-#{@pw_list.length}): "
    num = STDIN.gets.chomp.to_i - 1
    @pw_list.delete_at(num)
  end
end

class Starbound_Server
  attr_reader :options, :changed

  def initialize
    # Configure option parsing
    @options = {}
    @opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: ./sbserve.rb file1 [options]"

      opts.on('-h', '--help', 'Displays help') do
        puts opts
        exit
      end

      opts.on('-w', '--password', 'Edit password list') do
        @options[:password] = true
      end
      
      opts.on('-n', '--name [NAME]', 'View/Set Server Name') do |name|
        @options[:name] = name
      end

      opts.on('-p', '--port [PORT]', 'View/Set Server Port') do |port|
        @options[:port] = port
      end

      opts.on('-f', '--port_forward ON/OFF', [:on, :off], 'Turn Port Forwarding On/Off') do |port_fwd|
        @options[:port_fwd] = true if port_fwd == :on
        @options[:port_fwd] = false if port_fwd == :off
      end
    end

    @changed = false
  end

  def parse(arguments)
    @opt_parser.parse!(arguments)
  end

  def load(server_file)
    # Load server file
    begin
      file = File.open(server_file, 'r')
      @data = JSON.parse(file.read)
      file.close
    rescue Errno::ENOENT => e
      puts "ERROR - #{e.message}"
      exit
    end
  end

  def name
    if @options[:name].nil?
      puts "The server's name is: #{@data["serverName"]}."
    else
      @data["serverName"] = @options[:name]
      puts "The server's name has been set to \"#{@data["serverName"]}.\""
      @changed = true
    end
  end

  def port
    if @options[:port].nil?
      puts "The server's port is: #{@data["gamePort"]}."
    else
      @data["gamePort"] = @options[:port]
      puts "The server's port has been set to: #{@data["gamePort"]}."
      @changed = true
    end
  end

  def port_fwd
    @data["upnpPortForwarding"] = @options[:port_fwd]
    puts "Port forwarding has been turned #{@data["upnpPortForwarding"] ? "on" : "off"}."
    @changed = true
  end

  # Print the password list and prompt user for changes
  def change_passwords
    pw_list = Password_List.new(@data["serverPasswords"])

    loop do
      pw_list.print_list
      print "Enter 'a'/'d'/'e' (add/delete/enter): "
      input = STDIN.gets.chomp.downcase

      case input
      when 'a'
        pw_list.add
        @changed = true
      when 'd'
        pw_list.delete
        @changed = true
      when 'e'
        break
      else
        puts "ERROR: Invalid input - try again."
      end
      puts ''
    end

    @data["serverPasswords"] = pw_list
  end

  def write(filename)
    begin
      file = File.open(filename, 'w')
      file.puts JSON.generate(@data, JSON_OPTS)
      file.close
      @changed = false
    rescue Errno::EACCES => e
      puts "ERROR - #{e.message}"
    end
  end
end

###############
# Main Script #
###############

sb_serve = Starbound_Server.new
sb_serve.parse(ARGV)
sb_serve.load(ARGV.first)

# Handle command options on selected server files
if sb_serve.options.has_key?(:name)
  sb_serve.name
end

if sb_serve.options.has_key?(:port)
  sb_serve.port
end

if sb_serve.options.has_key?(:port_fwd)
  sb_serve.port_fwd
end

if sb_serve.options.has_key?(:password)
  sb_serve.change_passwords
end

# Write file
sb_serve.write(ARGV.first) if sb_serve.changed
