easy-html-creator
=================

A simple project for fast HTML file creation, haml+sass+coffee+ruby+bootstrap+jquery -> static html -> ftp deploy

to start:
=======
 `git checkout git@github.com:dennisvandehoef/easy-html-creator.git`
 
 `cd easy-html-creator` 
 
 `bundle install`
 
 `bundle exec rake start`

TODO
=======
- add a demo sites that make sin
- refactor generators
- make it a gem and configurable
- load shared/helpers and test1/helpers dynamically
- decide if we use activesupport or extend the lib/activesupport_simulator_helper
- ftp deployment


Credits
=======

./ruby_files/generate.rb (*in the first commit and/or version 0.0.1*) is based on:
https://github.com/scarpenter/command_line_haml/blob/master/generate.rb

./ruby_files/server.rb (*in the first commit and/or version 0.0.1*) is based on:
https://practicingruby.com/articles/implementing-an-http-file-server
