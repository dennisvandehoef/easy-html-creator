easy-html-creator
=================

A simple prodject for fast HTML file createmend

to start:
  bundle
  rake start

TODO
=======
- refactor server
- load shared/helpers and test1/helpers dynamically
- load generators per config
- decide if we use activesupport or extend the simulator

Versions
=================

- **0.0.1** First wordking version
- **0.0.2** Dynamic rendering and remove all old files bevore rendering
- **0.1.0** Add SASS ans CoffeeScript
- **0.1.1** Copy images and other static files

Credits
=======

./ruby_files/generate.rb (*in the first commit and/or version 0.0.1*) is based on:
https://github.com/scarpenter/command_line_haml/blob/master/generate.rb

./ruby_files/server.rb (*in the first commit and/or version 0.0.1*) is based on:
https://practicingruby.com/articles/implementing-an-http-file-server
