Gem::Specification.new do |s|
  s.name        = 'easy_html_creator'
  s.version     = '1.0.0'
  s.licenses    = ['MIT']
  s.summary     = "A simple project for fast and easy HTML website createmend"
  s.description = "Easy_html_creator is a gem that makes developing static HTML websites easy and joyful.

Once you learned the joy of haml or sass, it get boring to program in 'plain old' html and css.

Using our Gem you could generate and maintain multiple static websites and program them in your preferred languages.

Currently supported by our fast and lightweight re-generation server:
HAML
Sass (with bootstarp)
CoffeeScript

We also included the 'actionview' gem, to enable the use of rails standard functions like 'text_field_tag'."
  s.authors     = ["Tom Hanolt", "Dennis van de Hoef"]
  s.files       = ["lib/easy_html_creator.rb",
                   "lib/generator/coffee_generator.rb",
                   "lib/generator/generator.rb",
                   "lib/generator/haml_generator.rb",
                   "lib/generator/sass_generator.rb",
                   "lib/generator/structure_generator.rb",
                   "lib/server/dispatcher.rb",
                   "lib/server/request.rb",
                   "lib/server/response.rb",
                   "lib/server/server.rb",
                   "Gemfile",
                   "Rakefile",
                   "LICENSE",
                   "README.md",
                   "CHANGELOG.md"]
  s.homepage    = 'https://github.com/dennisvandehoef/easy-html-creator'

  s.executables = 'start'

  s.add_runtime_dependency 'haml'
  s.add_runtime_dependency 'sass'
  s.add_runtime_dependency 'coffee-script'
  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'bootstrap-sass'
  s.add_runtime_dependency 'actionview'
end
