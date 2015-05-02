# Changelog


## (unreleased)

* `@source` imports template as source (without execution)
* `@default option: value` and `@default @command; option: value` to [set default options for
  filters](https://github.com/livingstyleguide/livingstyleguide/issues/125)
* `@data` supports YAML data
* Ruby < 2.0 not officially supported anymore
* `@head`, `@header`, and `@footer` commands for injecting HTML
* `@css` also supports Sass’ indented syntax by setting
  `@css preprocessor: sass`
* `@javascript-before` and `@javascript-after` commands to link or
  insert JavaScript into the document


## 2.0.0.alpha.5

* [Use Tilt to render examples](https://github.com/hagenburger/livingstyleguide/issues/120) and allow all templating engines supperted by Tilt by `@type enginename`
* Markdown files (_*.md_) are rendered as Markdown (was rendered as LSG
  file)
* `@type` to change type of document within the document
* Normal code blocks (without example, just syntax highlighted) work
  from now on
* Commands can have blocks without braces or indented code from now on
  (add a colon at the end of the command to use this)
* Commands can have options (like JSON/Ruby hashes)
* `@set` can set multiple options
* Adding custom filters has been refactored to:
  `LivingStyleGuide.add_filter :name do |array_of_arguments, options_hash, block_string|`
* `@font-example` works with multiple fonts separated by comma
* Commas and quotation marks can be escaped in arguments/options (\, \" \')
* Added `@style` commands to [customize the style guide’s own style](https://github.com/livingstyleguide/livingstyleguide/issues/126)


## 2.0.0.alpha.4

* [Added `@require` to load any Ruby file or Gem](https://github.com/hagenburger/livingstyleguide/issues/109)
* [Renamed `@scss` command to `@css`](https://github.com/hagenburger/livingstyleguide/issues/128)
* [Use `@css my-styles.scss` instead of `@import my-styles.scss` for
  Sass/CSS files](https://github.com/hagenburger/livingstyleguide/issues/128)
* Refactored `***` highlights in code to not conflict with the syntax
  highlighter; now it’s possible to place them anywher without breaking
  the code
* Compass support within Sass code
* Avoid HTML escaping/rewriting/parsing by Markdown
* Fixed parsing of indented filters at the end of the file
* [Fixed Sprockets dependencies for non-LSG files](https://github.com/hagenburger/livingstyleguide/issues/127)
* Added `@title` filter to set the title of the HTML document


## 2.0.0.alpha.3

* Refactored Sass rendering: Better support for helpers and load paths
  for Rails/Sprockets/Middleman/Compass
* `@import` uses relative paths (to current _*.lsg_ file) from now on
* Sass dependencies are considered for cache invalidation in Sprockets
* ERB templates are rendered as expected


## 2.0.0.alpha.2

* Upgraded [@javascript filter](https://github.com/hagenburger/livingstyleguide/blob/v2/test/unit/filters/javascript_test.rb) to v2
* Upgraded [@coffee-script/@coffee filter](https://github.com/hagenburger/livingstyleguide/blob/v2/test/unit/filters/coffee_script_test.rb) to v2
* Upgraded the command line interface to use v2
* Added ID to examples to allow CSS scoping
* Fixed HTML (non-Haml) examples
* Upgraded code highlights to v2
* Removed obsolete v1 code and tests


## 2.0.0.alpha.1

* [New filter syntax everywhere](http://www.hagenburger.net/BLOG/livingstyleguide-2.html) (as it used to be within examples: Now everywhere in the file and the root document)
* [Importing](https://github.com/hagenburger/livingstyleguide/blob/v2/test/unit/filters/import_test.rb#L9) (`@import coding-style.lsg`) of other files (LivingStyleGuide documents, HTML, Haml, …)
* Imported files can be rendered with [local data defined as JSON](https://github.com/hagenburger/livingstyleguide/blob/v2/test/unit/filters/import_test.rb#L110-L112)
* Importing supports [globbing of files](https://github.com/hagenburger/livingstyleguide/blob/v2/test/unit/filters/import_test.rb#L73)
* [#57](https://github.com/hagenburger/livingstyleguide/issues/57): Having [multiple](https://github.com/hagenburger/livingstyleguide-concept/blob/master/c_new-multiple-pages-v2.0x/atoms.html.lsg#L2) [LivingStyleGuide](https://github.com/hagenburger/livingstyleguide-concept/blob/master/c_new-multiple-pages-v2.0x/index.html.lsg#L1) [documents](https://github.com/hagenburger/livingstyleguide-concept/blob/master/c_new-multiple-pages-v2.0x/pages.html.lsg#L2) by sharing [the configuration](https://github.com/hagenburger/livingstyleguide-concept/blob/master/c_new-multiple-pages-v2.0x/_config.lsg) and loading it via `@import config.lsg`)
* All imported files and all code examples will be grouped in a `<section>` with unique ID (as ID the current file name will be used if available). This helps scoping CSS and allows linking.
* [#97](https://github.com/hagenburger/livingstyleguide/issues/97): No need to import/parse/render the whole Sass project (only color variables may be needed)
* [Sprockets dependencies](https://github.com/hagenburger/livingstyleguide/blob/v2/test/integration/sprockets_test.rb#L6) (except imports within Sass)
* [Colors do support](https://github.com/hagenburger/livingstyleguide/blob/v2/test/unit/filters/colors_test.rb#L72) Sass `functions()`, `#hex`, and `colorconstants` besides `$variables`
* SCSS code can be [added everywhere](https://github.com/hagenburger/livingstyleguide/blob/v2/test/unit/filters/scss_test.rb#L7-L11) when needed (within examples, it will be automatically scoped to this example)


## 1.2.2

* [#105](https://github.com/hagenburger/livingstyleguide/issues/105): Better support of `sass-rails` in various versions
* [#107](https://github.com/hagenburger/livingstyleguide/issues/107): Fixed typo


## 1.2.1

* Fixed rare UTF-8 problems
* Fixed NoMethodError when using image-url


## 1.2.0

* **Internal:**
  * Refactored variable generation


## 1.2.0.pre.2

* CLI shows version
* CLI supports reading from STDIN
* CLI supports writing to STDOUT
* CLI supports output file
* Import Markdown once, even when Sass is imported twice
* The command line interface also supports _*.lsg_ files (without having
  _.html_ in the filename)


## 1.2.0.pre.1

* CLI works without having Bundler installed
* Compass is not required anymore (but still works well)
* Deprecated `list-variables()` in SassScript for v2.0.0
* Fixed [wrong/duplicate imports](https://github.com/hagenburger/livingstyleguide/issues/91) when importing Compass files
* **Internal:**
  * Removed importer => insprect Sass tree
  * Removed variables lookup => inspect Sass tree
  * Refactored code and file structure


## 1.1.1

* Fixed two CSS reseting problems that slightly broke the design
  ([#82](https://github.com/hagenburger/livingstyleguide/issues/82),
[#85](https://github.com/hagenburger/livingstyleguide/issues/85))


## 1.1.0

* Automatically find project root by Git root, Gemfile, or Rails root
* [Allow JavaScript code](https://github.com/hagenburger/livingstyleguide/issues/80) in `javascript-before` and `javascript-after`
* Configurable `text-align` for `base` and `headline`
* [Fixed styling](https://github.com/hagenburger/livingstyleguide/issues/76) of `<ul>`/`<ol>`


## 1.0.6

* Support for variables that contain numbers in their name


## 1.0.5

* Simulate `inspect(...)` for Sass < 3.3


## 1.0.4

* Compatibility with [Padrino](http://www.padrinorb.com)
* Fixed an error caused when maps are used
* [Anchors are close to headlines when centered](https://github.com/hagenburger/livingstyleguide/issues/52) from now on
* [Escape fonts in examples](https://github.com/hagenburger/livingstyleguide/issues/51)
* **Internal:**
  * Use Sass 3.3 and Compass 1.0.0 for automated tests


## 1.0.3

* Less Compass dependencies (not required in Sass anymore)
* More stable style guide design


## 1.0.2

* Fixed an issue where the command line interface used the input
  filename as the output filename
* Fixed an error causes by Compass’ `brightness()` function in 1.0.0
  alpha versions
* Fixed asset URL handling with Middleman and Sprockets
* **Internal:**
  * Integrated the website into the repository
  * Added the
    [changelog](http://livingstyleguide.org/changelog.html) to the website
  * Automated website deployment after a new version of the gem is
    released


## 1.0.1

* Fixed dependencies for broken gems


## 1.0.0

* New design and API for colors
* [Show anchors next to headlines](https://github.com/hagenburger/livingstyleguide/issues/23)
* [JSON for config files](https://github.com/hagenburger/livingstyleguide/issues/37)
* Updated styling of the style guide


## 1.0.0.alpha.3

* [Cache control for Sprockets](https://github.com/hagenburger/livingstyleguide/issues/25)
* API to provide [filters in examples](https://github.com/hagenburger/livingstyleguide/issues/22)
* Dropped `haml-example`, `layout-example`, `javascript-example` and `haml-layout-example`;
  moved into [filters](https://github.com/hagenburger/livingstyleguide/issues/28)
* [A set of pre-defined filters](https://github.com/hagenburger/livingstyleguide/tree/master/lib/livingstyleguide/filters)
* [Default filters](https://github.com/hagenburger/livingstyleguide/issues/31) (e. g. all templates should use Haml)
* [CoffeeScript examples](https://github.com/hagenburger/livingstyleguide/issues/34)


## 0.6.0.alpha.2

* Better support for load paths in Rails
* Fix for colors
* New YAML based configuration
  ([see this gist](https://gist.github.com/hagenburger/7945859#file-styleguide-1-html-lsg))
* Option to set the HTML title
* Custom footer and header HTML
  ([example](https://github.com/hagenburger/livingstyleguide/blob/master/test/fixtures/standalone/styleguide-with-header-footer.html.lsg))
* Linking of JavaScript files (like jQuery, application.js, …) into the
  style guide
  ([example](https://github.com/hagenburger/livingstyleguide/blob/master/test/fixtures/standalone/styleguide-with-javascript.html.lsg))
* Custom styles can be set within YAML configuration
  ([example](https://github.com/hagenburger/livingstyleguide/blob/master/test/fixtures/standalone/styleguide-with-style.html.lsg))


## 0.6.0.alpha.1

* Added Rails support
* Removed globbing
* Set .html.lsg as default file extension


## 0.6.0.alpha.0

* Implemented command line interface


## 0.5.2

* More stable CSS


## 0.5.1

* Fixed highlighting in Haml code examples
* Use the Haml syntax highlighter


## 0.5.0

* Added support for Haml code in examples (`haml-example`,
  `haml-layout-example`)


## 0.4.2

* Added `display` properties to avoid conflicts with resets


## 0.4.1

* Added anchors (ids) to headlines
