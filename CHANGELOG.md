# Changelog

## 1.2.2

* #105: Better support of `sass-rails` in various versions
* #107: Fixed typo


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

