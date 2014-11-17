require 'optparse'
require 'fileutils'

class EhcCommandTasks

  COMMAND_WHITELIST = %w(init generate server help)
  HELP_MESSAGE      = <<-EOT
    Usage: ehc COMMAND [ARGS]

    The avalible commands are:
    init      Initialize 'dev_root' and 'web_root' with a demo website
    generate  Only generate output files  (short-cut alias: "g")
    server    Start the wserver (short-cut alias: "s")
    help      Shows this message

  EOT

  def initialize
    command = parse_command
    if COMMAND_WHITELIST.include?(command)
      send(command)
    else
      print_error(command)
    end
  end

  def parse_command
    return "" if ARGV.empty?

    command =  ARGV.first

    if command == 'g'
      command = 'generate'
    elsif command == 's'
      command = 'server'
    end
    return command
  end

  def print_error(command)
    if command.empty?
      puts 'no command given'
    else
      puts "command '#{command}' not valid"
    end if
    help
  end

  def help
    puts HELP_MESSAGE
  end

  def init
    puts "Creating dev_root and web_root with sample website"

    init_dev_root
    init_web_root

    puts "All done, use 'ehc server' to start the development server."
  end

  def generate
    require 'generator/generator'
    Generator::Generator.new.generate
  end

  def server
    options = parse_server_options
    require 'easy_html_creator'
  end

  private

  def init_dev_root
    source_dir = File.expand_path(File.dirname(__FILE__))[0..-4]
    output_folder = "#{Dir.pwd}/dev_root"

    unless File.directory? output_folder
      FileUtils::mkdir_p output_folder
      FileUtils::copy_entry("#{source_dir}dev_root", output_folder)
    end
  end

  def init_web_root
    unless File.directory? "#{Dir.pwd}/web_root"
      FileUtils::mkdir_p "#{Dir.pwd}/web_root"
    end
  end

  def parse_server_options
    options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: example.rb [options]"

      options[:port] = 5678
      opts.on( '-p', '--port', 'Port number for the webserver' ) do |port|
        options[:port] = port
      end

      options[:ip] = '127.0.0.1'
      opts.on( '-i', '--ip-adres', 'Ip adres for the webserver on' ) do |ip|
        options[:ip] = ip
      end

      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end.parse!
    options
  end
end
