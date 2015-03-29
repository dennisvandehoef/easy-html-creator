require_relative 'sass_generator.rb'
require_relative 'coffee_generator.rb'
require_relative 'haml_generator.rb'
require_relative 'structure_generator.rb'
require_relative 'bower_generator.rb'

SassGenerator::add_load_path('./dev_root/shared/sass')

module Generator
  class Generator
    def initialize
      @generators = [ BowerGenerator.new,
                      StructureGenerator.new,
                      CoffeeGenerator.new,
                      SassGenerator.new,
                      HamlGenerator.new ]
    end

    def web_root
      return 'web_root'
    end

    def dev_root
      return 'dev_root'
    end

    def projects_folder
      Dir.glob("#{dev_root}/*")
    end

    def project_name project_folder
      project_folder.split('/')[-1]
    end

    def project_web_folder project
      "#{web_root}/#{project}"
    end

    def generate(path=nil)
      if path
        files = [File.dirname(path)]
      else
        files = projects_folder
      end

      files.each do |project_folder|
        next unless File.directory? project_folder
        next if project_folder.include? 'shared'

        project_name = project_folder.split('/')[-1]
        project_output_folder = project_web_folder(project_name)

        puts "generating: \e[32m#{project_output_folder}\e[0m"
        @generators.each do |generator|
          generator.generate(project_folder, project_output_folder)
        end
      end
    end
  end
end
