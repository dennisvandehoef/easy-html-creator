1.2.1
=================
- Add polymer demo website
- refactor generators
- increase performance
- regenerate file only if file hash changed
- coffee inline available via = with_coffe do
- sass inline available via = with_sass do
- only generate requested project, to generate all projects use "ehc generate"

1.2.0
=================
- Add mixins for reset, resize, buttons, arrows and extend existing helper mixins
- Add bower.json resolving in public folder
- Add offline demo website with bower dependencies
- Add file_exists to helper methods
- reload ruby helpers on each request, so you don't need to restart the server
- better exceptions for partials
- sass include path for shared sass files now starts from dev_root/shared/sass
- list directory contents if there is no index.html

1.1.1
=================
- We removed a forgotten ‘Require ‘pry”

1.1.0
=================
- Add easy commands to start the server (`ehc server`) and to parse the dev_root (`ehc generate`)
- Add the ActiveSupport gem with overrides to fix Rails dependicies
- Make the demo website better
- Add a documentation website to the dev_root (it's also hosted here: http://easyhtmlcreator.bplaced.net/)

1.0.0
=================
We released our project as a gem (https://rubygems.org/gems/easy_html_creator)

0.1.2
=================
Project helper and add actionview for hml files

0.1.1
=================
Copy images and other static files

0.1.0
=================
Add SASS and CoffeeScript

0.0.2
=================
Dynamic rendering and remove all old files before rendering

0.0.1
=================
First working version
