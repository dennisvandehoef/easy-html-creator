require 'rake'

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
