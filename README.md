# LivingStyleGuide ![Build Status Images](https://travis-ci.org/livingstyleguide/livingstyleguide.png)

Easily create living style guides/front-end style guides/pattern libraries by adding Markdown documentation to
your Sass project. [Follow @LSGorg](https://twitter.com/LSGorg) for updates.

![preview](https://cloud.githubusercontent.com/assets/103399/3854622/2fb68574-1eda-11e4-862c-33e7d7943c56.jpg)

* On the left: http://www.homify.de/assets/styleguide.html (non-public repository)
* On the right: http://livingstyleguide.com/eurucamp/ ([public repository](https://github.com/eurucamp/livingstyleguide-eurucamp))

----


## Getting Started

* [Command Line Interface](#command-line-interface)
* [Rails Integration](#rails-integration)
* [Middleman Integration](#middleman-integration)
* [Grunt](#grunt)
* [Gulp](#gulp)
* [Broccoli](#broccoli)
* [Ember CLI](#ember-cli)
* [Writing Examples](#writing-examples)
* [Styling the Style Guide](#styling-the-style-guide)


## Command Line Interface

1. Setup
   ```
   $ gem install livingstyleguide
   ```

2. Create *_sass/styleguide.lsg_* (replace `sass/` with the directory name of your Sass files) with:
   ``` yaml
   source: 'application.scss' # replace with your default Sass/SCSS file name
   title: 'My Living Style Guide'
   ```

3. Write documentation for each module *sass/partials/_buttons.md* (to describe *_buttons.scss* in the same folder):

        Buttons
        =======

        ```
        <button class="button">Example button</button>
        ```

        ```
        <button class="button -primary">Example button</button>
        ```

4. Call `livingstyleguide compile sass/styleguide.lsg public/styleguide.html`
   This will automatically:
   * Combine all Markdown files and convert them to HTML
   * Create a beautiful style guide
   * Saves the style guide as _public/styleguide.html_
   * Show the HTML source syntax highlighted close to each example


### Tips for the Command Line Interface

* Create your project with or without [Compass](http://compass-style.org).
* This can be easily integrated into non-Ruby build systems.
* If you omit the input and output filenames, STDIN and STDOUT will be used.


## Rails Integration

1. Setup:
   Add this line to your application’s _Gemfile_:

   ``` ruby
    gem 'livingstyleguide'
   ```

   And then execute:

   ```
    $ bundle
    $ rails s
   ```

2. Create *_app/assets/stylesheets/styleguide.html.lsg_* with:
   ``` yaml
   source: 'application.css.scss' # replace with your default Sass/SCSS file name
   title: 'My Living Style Guide'
   ```

3.  Write documentation for each module *app/assets/stylesheets/partials/_buttons.md* (to describe *_buttons.sass* in the same folder):

        Buttons
        =======

        ```
        <button class="button">Example button</button>
        ```

        ```
        <button class="button -primary">Example button</button>
        ```

4. Open <http://localhost:3000/assets/styleguide.html>.
   This will automatically:
   * Combine all Markdown files and convert them to HTML
   * Create a beautiful style guide
   * Show the HTML source syntax highlighted close to each example

### Tips for Rails

*  Add the _styleguide.html_ to the precompile list in _config/application.rb_:

   ``` ruby
   config.assets.precompile += ['styleguide.html']
   ```
* There is a [Rails example application](https://github.com/livingstyleguide/livingstyleguide-example/tree/master/rails-example) available on Github.
*  Use _sass-rails_ > v5 to allow _Sass_ > v3.2:

   ``` ruby
   # Gemfile:
   gem 'sass-rails', '~> 5.0.0.beta1'
   ```
   
   See [issue #99](https://github.com/livingstyleguide/livingstyleguide/issues/99) for discussions.

### Using it with Rails 4

Since Rails 4 non-digest assets are not created anymore. If you want a public sharable url consider using something like [Non Stupid Digest Assets](https://github.com/alexspeller/non-stupid-digest-assets)


## Middleman Integration

1. Setup:
   Add this line to your application’s _Gemfile_:

   ```
    gem 'livingstyleguide'
   ```

   And then execute:

   ```
    $ bundle
    $ middleman
   ```

2. Create *_source/styleguide.html.lsg_* with:
   ``` yaml
   source: 'css/application.css.scss' # replace with your default Sass/SCSS file name
   title: 'My Living Style Guide'
   ```

3. Write documentation for each module *source/css/partials/_buttons.md* (to describe *_buttons.sass* in the same folder):

        Buttons
        =======

        ```
        <button class="button">Example button</button>
        ```

        ```
        <button class="button -primary">Example button</button>
        ```

4. Open <http://localhost:4567/styleguide.html>.
   This will automatically:
   * Combine all Markdown files and convert them to HTML
   * Create a beautiful style guide
   * Show the HTML source syntax highlighted close to each example

### Tips for Middleman

* Don’t put the _styleguide.html.lsg_ into your CSS folder (`source/css/`). It won’t work.
* There is a [Middleman example application](https://github.com/livingstyleguide/livingstyleguide-example/tree/master/middleman-example) available on Github.
* A more complex production project can [be found online](http://livingstyleguide.com/eurucamp/). The complete source of this Middleman project [is available on Github](https://github.com/eurucamp/livingstyleguide-eurucamp). You’ll find a lot of configuration on how to make the style guide look beautiful.


## Grunt

See [NexwayGroup/grunt-livingstyleguide](https://github.com/NexwayGroup/grunt-livingstyleguide#readme).


## Gulp

See [efacilitation/gulp-livingstyleguide](https://github.com/efacilitation/gulp-livingstyleguide#readme).


## Broccoli

See [hagenburger/broccoli-livingstyleguide](https://github.com/hagenburger/broccoli-livingstyleguide#usage).


## Ember CLI

See [hagenburger/broccoli-livingstyleguide](https://github.com/hagenburger/broccoli-livingstyleguide#usage) (comments on Ember CLI can be found there).


----


## Writing Examples

A default example outputs the HTML source as:

* Real HTML in a wrapper to display the results
* Syntax-highligted code below

Example:

    ```
    <button class="button">Example button</button>
    ```

There are more **filters** to generate output. They start with an `@` and can be put in the code block:


### Colors

This will generate a list ($name + #value in a circle of that color) of all color variables found in *variables/_colors.scss*:

    ```
    @colors variables/colors
    ```

Alternatively you can set the colors you want to output yourself (much better for grouping different shades of one color). `-` leaves a cell in the matrix empty:

    ```
    @colors
    -       $light-red  $gray
    $green  $red        -
    -       $dark-red   $black
    ```


### Haml Examples

This will output the code as HTML but display the syntax highlighted
source as Haml ([learn how to use Haml by default](#default-filters)):

    ```
    @haml
    %button.button Example button
    ```


### Handlebars.js (and other JavaScript templating languages) Examples

This requires some configuration which is explained in a [blog post on how to use Handlebars.js in the LivingStyleGuide](http://www.hagenburger.net/BLOG/handlebars-js-templates-living-style-guide.html). This blog post also shows how to load templates from other locations and use JSON to compile them in the style guide.


### JavaScript Examples

This will show and execute the JavaScript, e. g. you designed tabs and
need few lines of jQuery to bring them alive.

    ```
    @javascript
    $('.button').click(function() {
      alert('Hello World!');
    });
    ```


### CoffeeScript Examples

Same example but using [CoffeeScript](http://coffeescript.org). It will be
executed as JavaScript and displayed as CoffeeScript:

    ```
    @coffee-script
    $('.button').click ->
      alert 'Hello World!'
    ```


### Font Examples

Show which fonts should be used on your website—this will output and example text block (A—Z, a—z, 0—9, and some special characters) of the given font. It accepts valid CSS like for `font: 32px Comic Sans;`.

    ```
    @font-example 32px Comic Sans
    ```

Use your own text (defaults to “ABC…\nabc…\n123…\n!&…” if not set):

    ```
    @font-example 32px Comic Sans
    Schweißgequält zündet Typograf Jakob
    verflixt öde Pangramme an.
    ```


### Output Code

If you just want to output code with no extras (just like in a normal Markdown file), you only need to add the language:

    ``` html
    <div>Some HTML that just gets syntax-higlighted but not put into the document’s DOM</div>
    ```

No syntax highlighter:

    ``` plain
    <div>Some HTML that just gets syntax-higlighted but not put into the document’s DOM</div>
    ```


### Default Filters

You can set filters to apply to all examples.
This is useful, when you depend on Haml or other templating engines.
Add a list of default filters to your _styleguide.html.lsg_:

``` yaml
default-filters:
  - '@haml'
```

**Info:** YAML will fail if you don’t use quotation marks here. You should not use `@coffee-script` as default filter.


## Styling the Style Guide

### Custom Header

The examples in [the screenshot above](#readme) use custom headers to have an individual look.
You can add whatever HTML you want and some Sass to style it to your _styleguide.html.lsg:_

``` yaml
header: |
  <div class="my-header">
    <img src="logo.svg">
  </div>

styleguide-scss: |
  .my-header {
    background: red;
    text-align: center;
    padding: 100px;
  }
```

[Here’s the code](https://github.com/eurucamp/livingstyleguide-eurucamp/blob/master/source/index.html.lsg#L71-L80) of the custom header in the example of the screenshot.


### Custom Footer

See [Custom Header](#custom-header), just use `footer:`.


### Custom Settings

Most of the design of the style guide itself, is calculated by few variables in the _styleguide.html.lsg:_

``` yaml
style:
  base-font: 'Comic Sans MS, Arial, sans-serif'
  base-font-size: '7em'
  background-color: 'red'
  border-color: '$my-color'
  color: '#eee'
  code-color: 'darken(red, 10%)'
  color-swatch-border-radius: '0'
```

* For a full list of options, [have a look at the source](https://github.com/livingstyleguide/livingstyleguide/blob/master/stylesheets/_livingstyleguide.scss) (just strip `$livingstyleguide--` from the variables).
* Every Sass expression is allowed
* Variables defined in your production Sass are available
* `code-color` generates a whole color scheme for syntax highlighting in your corporate colors
* `color-swatch-border-radius: 0` creates squared color swatches

Just play a bit and create an individual style guide which represents your personal taste :)


## Including JavaScript

If you need external JavaScript files to be included in the style guide, there are two options: before (in the `<head>`) or after (just before the closing `</body>`). It accepts a list of URLs (ending with `*.js`) or plain JavaScript code:

``` yaml
javascript-before:
  - "assets/modernizr.js"

javascript-after:
  - "http://code.jquery.com/jquery-1.11.1.min.js"
  - "assets/application.js"
  - |
    $(function() {
      // custom code
    });
```

If you use [@javascript](#javascript-examples) or [@coffee-script](#coffeescript-examples), your application files and jQuery might need to be included in the `javascript-before` section.


----


## Installation

Add this line to your application’s Gemfile:

``` ruby
gem 'livingstyleguide'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install livingstyleguide


----


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


----


## Copyright

Copyright 2012—2014 [Nico Hagenburger](http://www.hagenburger.net).
See [MIT-LICENSE.md](MIT-LICENSE.md) for details.
Get in touch with [@hagenburger](http://twitter.com/hagenburger) on Twitter or [open an issue](https://github.com/livingstyleguide/livingstyleguide/issues/new).

