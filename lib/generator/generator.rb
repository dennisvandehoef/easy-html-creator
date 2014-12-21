require_relative 'sass_generator.rb'
require_relative 'coffee_generator.rb'
require_relative 'haml_generator.rb'
require_relative 'structure_generator.rb'

module Generator
  class Generator
    def initialize
      @haml      = HamlGenerator.new
      @sass      = SassGenerator.new
      @coffee    = CoffeeGenerator.new
      @structure = StructureGenerator.new
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

    def generate
      FileUtils.rm_rf(Dir.glob("web_root/*"))

      projects_folder.each do |project_folder|
        next unless File.directory? project_folder
        next if project_folder.include? 'shared'

        project_name = project_folder.split('/')[-1]
        project_output_folder = project_web_folder(project_name)

        @structure.generate project_folder, project_output_folder
        @haml.generate      project_folder, project_output_folder
        @coffee.generate    "#{project_folder}/coffee", "#{project_output_folder}/js"
        @sass.generate      "#{project_folder}/sass"  , "#{project_output_folder}/css"
      end
    end
  end
end
