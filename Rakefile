require 'rake'
require './lib/generator/generator'

desc "generates the content"
task :generate do
  Generator::Generator.new.generate
end

desc "starts the server"
task :start do
  `ruby lib/easy_html_creator.rb`
end

desc "runs the tests"
task :test do
  puts "run rake start and do manually ;)"
end
