easy-html-creator
=================
Easy_html_creator is a gem that makes developing static HTML websites easy and joyful.

Once you learned the joy of haml or sass, it get boring to program in "plain old" html and css.

Using our Gem you could generate and maintain multiple static websites and program them in your preferred languages.

Currently supported by our fast and lightweight re-generation server:
HAML
Sass (with bootstarp)
CoffeeScript

We also included the "actionview" gem, to enable the use of rails standard functions like "text_field_tag".

start it!
=======
 `git clone git@github.com:dennisvandehoef/easy-html-creator.git`

 `cd easy-html-creator`

 `bundle install`

 `bundle exec rake start`

  ...follow the console output and open a webbrowser

TODO
========
- clean/refactor code
- Add tests

Credits
=======

./ruby_files/generate.rb (*in the first commit and/or version 0.0.1*) is based on:
https://github.com/scarpenter/command_line_haml/blob/master/generate.rb

./ruby_files/server.rb (*in the first commit and/or version 0.0.1*) is based on:
https://practicingruby.com/articles/implementing-an-http-file-server
