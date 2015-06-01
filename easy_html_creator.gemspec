Gem::Specification.new do |s|
  s.name        = 'easy_html_creator'
  s.version     = '1.3.0'
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
  s.authors     = ["Tom Hanoldt", "Dennis van de Hoef"]
  s.email       = ['monotom@gmail.com', 'dennisvdhoef@gmail.com']
  s.files       = Dir.glob("{bin,lib,dev_root}/**/*") + %w(LICENSE README.md CHANGELOG.md)
  s.homepage    = 'http://easyhtmlcreator.bplaced.net'

  s.executables = ["ehc",
                   "easy_html_creator"]

  s.required_ruby_version = '>= 2.0.0'

  s.add_runtime_dependency 'haml'
  s.add_runtime_dependency 'sass'
  s.add_runtime_dependency 'coffee-script'
  s.add_runtime_dependency 'bootstrap-sass'
  s.add_runtime_dependency 'actionview'
  s.add_runtime_dependency 'cssminify'
  s.add_runtime_dependency 'uglifier'



  s.add_development_dependency 'rake'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'minitest-reporters'
end
