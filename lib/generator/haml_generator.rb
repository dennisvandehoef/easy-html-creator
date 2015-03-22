require 'fileutils'
require 'haml'
require 'action_view'

require_relative 'helper/activesupport_override.rb'
require_relative 'helper/asset_helper.rb'
require_relative 'base.rb'

module Generator
  class HamlGenerator < Generator::Base
    def initialize()
      @example_boolean = false
      @haml_options = { attr_wrapper: '"', format: :html5 }
    end

    def generate(input_folder, output_folder)
      layout_path = "#{input_folder}/layout.haml"
      layout      = Haml::Engine.new(File.read(layout_path), @haml_options)

      Dir.glob("#{input_folder}/*.haml").select do |input_file|
        next unless File.file? input_file and !input_file.include? 'layout.haml'

        output_file_name = input_file.split('/')[-1].gsub('.haml', '.html')
        output_file      = File.join(output_folder, output_file_name)
        scope            = output_file_name.split('.').first
        context          = Context.new(@example_boolean, scope, @haml_options,
                                      input_folder, output_folder)

        compile_file(input_file, output_file, layout, context, scope)
      end
    end

    def compile(input, output_file, layout, context, scope)
      # If the file being processed by Haml contains a yield statement, the block passed to
      # "render" will be called when it's hit.
      layout.render context, body_class: scope do
        # Render the actual page contents in place of the call to "yield".
        body = Haml::Engine.new(input, @haml_options)
        body.render(context)
      end
    rescue Exception => e
      raise $!, "#{$!} TEMPLATE::#{output_file} ", $!.backtrace
    end

    def changed?(path)
      true #allways recompile haml because of partials etc.
    end
  end

  # Calls to "render" can take a context object that will be accessible from the templates.
  class Context
    # Any properties of this object are available in the Haml templates.
    attr_reader :example_boolean

    include ActionView::Helpers
    include ActivesupportOverride
    include AssetHelper

    def initialize(example_boolean, scope, options, input_folder, output_folder)
      @example_boolean = example_boolean
      @scope           = scope
      @options         = options
      @input_folder    = input_folder
      @output_folder   = output_folder

      load_helper('./dev_root/shared/helper/*.rb')
      load_helper("./#{input_folder}/helper/*.rb")
    end

    def load_helper(folder)
      Dir.glob(folder).each do |path|
        load path
        file_without_ext = path.split('/')[-1].split('.').first
        module_name      = file_without_ext.classify
        STDERR.puts '->loading project helper: '+module_name
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
    rescue Exception => e
      raise $!, "#{$!} PARTIAL::#{file_name} ", $!.backtrace
    end
  end
end
