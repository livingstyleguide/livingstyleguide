# Changelog

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
* [Show anchors naxt to headlines](https://github.com/hagenburger/livingstyleguide/issues/23)
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

