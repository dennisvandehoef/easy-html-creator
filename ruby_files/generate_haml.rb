#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"

require 'fileutils'
require "haml"

# Calls to "render" can take a context object that will be accessible from the templates.
class Context
  # Any properties of this object are available in the Haml templates.
  attr_reader :example_boolean

  def initialize(example_boolean, scope, options, folder)
    @example_boolean = example_boolean
    @scope = scope
    @options = options
    @folder = folder
  end

  # This is an example function that can be called inside Haml templates.
  def copyright_year
    start_year = 2013
    end_year = Time.now.year
    if end_year == start_year
      start_year.to_s
    else
      "#{start_year}&#8211;#{end_year}"
    end
  end

  # This function is no different from the "copyright_year" function above. It just uses some
  # conventions to render another template file when it's called.
  def render_partial(file_name)
    # The "default" version of the partial.
    file_to_render = "../dev_root/#{@folder}/partials/#{file_name.to_s}.haml"
    if @scope
      # Look for a partial prefixed with the current "scope" (which is just the name of the
      # primary template being rendered).
      scope_file = "../dev_root/#{@folder}/partials/#{@scope.to_s}_#{file_name.to_s}.haml"
      # Use it if it's there.
      file_to_render = scope_file if File.exists? scope_file
    end
    # If we found a matching partial (either the scoped one or the default), render it now.
    if File.exists? file_to_render
      partial = Haml::Engine.new(File.read(file_to_render), @options)
      partial.render
    else
      nil
    end
  end
end

class Generator
  def initialize(example_boolean)
    @example_boolean = example_boolean
    @output_dir = "../web_root/"
    FileUtils.rm_rf(Dir.glob("#{@output_dir}*"))

    # Change these to whatever makes sense for your needs.
    @haml_options = { attr_wrapper: '"', format: :html5 }
  end

  def create_structure(folder)
    return if File.directory? "#{@output_dir}#{folder}/"

    FileUtils::mkdir_p "#{@output_dir}#{folder}/"
  end

  def generate(folder, input_file)
    create_structure(folder)

    layout = Haml::Engine.new(File.read("../dev_root/#{folder}/layout.haml"), @haml_options)
    c = Context.new @example_boolean, input_file, @haml_options, folder

    # If the file being processed by Haml contains a yield statement, the block passed to
    # "render" will be called when it's hit.
    output = layout.render c do
      # Render the actual page contents in place of the call to "yield".
      body = Haml::Engine.new(File.read("../dev_root/#{folder}/#{input_file}.haml"), @haml_options)
      body.render c
    end

    output_path = File.join("#{@output_dir}#{folder}/", "#{input_file}.html")
    File.open(output_path, "w") do |f|
      f.write output
    end
  end
end

def do_generate_haml
  example_boolean = ARGV.length > 0 && (ARGV[0] == "true" || ARGV[0] == "yes")
  g = Generator.new example_boolean
  Dir.glob('../dev_root/*').select do |folder|
    next unless File.directory? folder
    folder = folder.split('/')[-1]
    Dir.glob("../dev_root/#{folder}/*.haml").select do |file|
      file_name = file.split('/')[-1]
      file_name_a = file_name.split('.')
      file_name = file_name_a.take(file_name_a.size-1) * '.'
      next unless File.file? file and file_name != 'layout'
      g.generate folder, file_name
    end
  end

end

if __FILE__==$0
  do_generate_haml
end
