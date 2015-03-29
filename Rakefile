require 'rake'
require 'rake/testtask'

desc "generates the content"
task :generate do
  require './lib/generator/generator'
  Generator::Generator.new.generate
end

desc "starts the server"
task :start do
  `ruby lib/easy_html_creator.rb`
end

desc "update documentation website"
task :update_doc do
  `./make_documentation.sh`
  `ehc generate`
  `ruby do_upload_documentation_to_webserver.rb`
end

Rake::TestTask.new do |t|
  t.libs = t.libs + %w(test lib lib/generator)
end

desc "Run tests"
task :default => :test
