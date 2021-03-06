easy_html_creator
=================
easy_html_creator is a gem that makes developing static HTML websites easy and joyful.

Once you learned the joy of haml or sass, it get boring to program in "plain old" html and css.

Using our Gem you could generate and maintain multiple static websites and program them in your preferred languages.

Currently supported by our fast and lightweight re-generation server:
 * HAML
 * Sass (with bootstarp)
 * CoffeeScript

We also included the "actionview" gem, to enable the use of rails standard functions like "text_field_tag".

Extended doumentation, can be found here: http://easyhtmlcreator.bplaced.net

Installation
=======
Add folliwing to your Gemfile

 `gem 'easy_html_creator'`

than run

 `bundle install`

Usage
=======

 `ehc init`
 This command will generate a sample dev_root and web_root folder

 `ehc generate`
 This command will generate all the files

 `ehc server [--ip-adres 127.0.0.1] [--port 5678]`
 This command will start a webserver with will automatically regenerate all the files


TODO
========
- clean/refactor code
- Add tests
- Add Travis intigration (https://travis-ci.org)

Stats
========

[![Gem Version](https://badge.fury.io/rb/easy_html_creator.png)](http://badge.fury.io/rb/easy_html_creator)

Credits
=======
*Files are located in the first commit and/or version 0.0.1*
- ./ruby_files/generate.rb is based on: https://github.com/scarpenter/command_line_haml/blob/master/generate.rb
- ./ruby_files/server.rb is based on: https://practicingruby.com/articles/implementing-an-http-file-server

Contributing
============
1. Fork it ( https://github.com/dennisvandehoef/easy_gravatar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Make sure the test walk trough (`rake test`)
6. Create a new Pull Request
