require 'fileutils'
require 'haml'
require 'action_view'

require_relative 'helper/activesupport_override.rb'

#require shared helper
$shared_helper = Dir.glob('./dev_root/shared/helper/*.rb')
$shared_helper.each do |file| require file end

module Generator
  class HamlGenerator
    def initialize()
      @example_boolean = false
      @haml_options = { attr_wrapper: '"', format: :html5 }
    end

    def generate input_folder, output_folder
      layout = "#{input_folder}/layout.haml"

      Dir.glob("#{input_folder}/*.haml").select do |file|
        next unless File.file? file and !file.include? 'layout.haml'

        result    = compile(file, layout, input_folder, output_folder)
        file_name = file.split('/')[-1].gsub('.haml', '.html')
        write File.join(output_folder, file_name), result
      end
    end

    def compile file, layout, input_folder, output_folder
      scope = file.split('/')[-1].split('.').first
      layout = Haml::Engine.new(File.read(layout), @haml_options)
      c = Context.new @example_boolean, scope, @haml_options, input_folder, output_folder

      # If the file being processed by Haml contains a yield statement, the block passed to
      # "render" will be called when it's hit.
      layout.render c, body_class: scope do
        # Render the actual page contents in place of the call to "yield".
        body = Haml::Engine.new(File.read(file), @haml_options)
        body.render(c)
      end
    end

    def write file, content
      File.open(file, "w") do |f|
        f.write content
      end
    end
  end

  # Calls to "render" can take a context object that will be accessible from the templates.
  class Context
    # Any properties of this object are available in the Haml templates.
    attr_reader :example_boolean

    include ActionView::Helpers
    include ActivesupportOverride

    $shared_helper.each do |path|
      file_without_ext = path.split('/')[-1].split('.').first
      module_name      = file_without_ext.classify
      STDERR.puts 'loading helper -> '+module_name
      include module_name.constantize
    end

    def initialize(example_boolean, scope, options, input_folder, output_folder)
      @example_boolean = example_boolean
      @scope = scope
      @options = options
      @input_folder = input_folder
      @output_folder = output_folder
      Dir.glob("./#{input_folder}/helper/*.rb").each do |path|
        require path
        file_without_ext = path.split('/')[-1].split('.').first
        module_name      = file_without_ext.classify
        STDERR.puts 'loading project helper -> '+module_name
        self.class.send(:include, module_name.constantize)
      end
    end

    # This function is no different from the "copyright_year" function above. It just uses some
    # conventions to render another template file when it's called.
    def render_partial(file_name)
      # The "default" version of the partial.
      file_to_render = "#{@input_folder}/partials/#{file_name.to_s}.haml"
      if @scope
        # Look for a partial prefixed with the current "scope" (which is just the name of the
        # primary template being rendered).
        scope_file = "#{@input_folder}/partials/#{@scope.to_s}_#{file_name.to_s}.haml"
        # Use it if it's there.
        file_to_render = scope_file if File.exists? scope_file
      end
      # If we found a matching partial (either the scoped one or the default), render it now.
      if File.exists? file_to_render
        partial = Haml::Engine.new(File.read(file_to_render), @options)
        partial.render self
      else
        nil
      end
    end
  end
end
