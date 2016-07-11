# LivingStyleGuide [![Build Status](https://travis-ci.org/livingstyleguide/livingstyleguide.svg?branch=v2)](https://travis-ci.org/livingstyleguide/livingstyleguide)

Easily create living style guides/front-end style guides/pattern libraries by adding Markdown documentation to
your Sass project. [Follow @LSGorg](https://twitter.com/LSGorg) for updates.

![preview](https://cloud.githubusercontent.com/assets/103399/3854622/2fb68574-1eda-11e4-862c-33e7d7943c56.jpg)

* On the left: http://www.homify.de/assets/styleguide.html (non-public repository)
* On the right: http://style-guide.eurucamp.org/2015/ ([public repository](https://github.com/eurucamp/livingstyleguide-eurucamp))

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
   ```
   // Replace with your default Sass/SCSS file name:
   @scss application.css.scss

   // Set the HTML title of the document:
   @title My Living Style Guide

   // Import all your style guide files
   @import sass/**/*.lsg
   ```

3. Write documentation for each module *sass/partials/_buttons.lsg* (to describe *_buttons.scss* in the same folder):


        # Buttons

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

Be aware: From LSG v2 on Rails 3.x is not supported due to outdated
Sprockets and Tilt versions.

1. Setup:
   Add this line to your application’s _Gemfile_:

   ``` ruby
   gem "livingstyleguide"
   ```

   And then execute:

   ```
   $ bundle
   $ rails s
   ```

2. Create *_app/assets/stylesheets/styleguide.html.lsg_* with:
   ```
   // Replace with your default Sass/SCSS file name:
   @scss application.css.scss

   // Set the HTML title of the document:
   @title My Living Style Guide

   // Import all your style guide files
   @import **/*.lsg
   ```

3.  Write documentation for each module *app/assets/stylesheets/partials/_buttons.lsg* (to describe *_buttons.sass* in the same folder):

        # Buttons

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
   config.assets.precompile += ["styleguide.html"]
   ```
* There is a [Rails example application](https://github.com/livingstyleguide/examples/tree/master/rails-example) available on Github.
*  Use _sass-rails_ > v5 to allow _Sass_ > v3.2:

   ``` ruby
   # Gemfile:
   gem "sass-rails", "~> 5.0.0.beta1"
   ```

   See [issue #99](https://github.com/livingstyleguide/livingstyleguide/issues/99) for discussions.


### Using it with Rails 4

Since Rails 4 non-digest assets are not created anymore. If you want a public sharable url consider using something like [Non Stupid Digest Assets](https://github.com/alexspeller/non-stupid-digest-assets)


## Middleman Integration

1. Setup:
   Add this line to your application’s _Gemfile_:

   ```
   gem "livingstyleguide"
   ```

   And then execute:

   ```
   $ bundle
   $ middleman
   ```

2. Create *_source/styleguide.html.lsg_* with:
   ```
   // Replace with your default Sass/SCSS file name:
   @scss application.css.scss

   // Set the HTML title of the document:
   @title My Living Style Guide

   // Import all your style guide files
   @import css/**/*.lsg
   ```

3. Write documentation for each module *source/css/partials/_buttons.lsg* (to describe *_buttons.sass* in the same folder):

        # Buttons

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
* There is a [Middleman example application](https://github.com/livingstyleguide/examples/tree/master/middleman-example) available on Github.
* A more complex production project can [be found online](http://livingstyleguide.com/eurucamp/). The complete source of this Middleman project [is available on Github](https://github.com/eurucamp/livingstyleguide-eurucamp). You’ll find a lot of configuration on how to make the style guide look beautiful.


## Grunt

See [NexwayGroup/grunt-livingstyleguide](https://github.com/NexwayGroup/grunt-livingstyleguide#readme).


## Gulp

See [efacilitation/gulp-livingstyleguide](https://github.com/efacilitation/gulp-livingstyleguide#readme).


## Broccoli

See [livingstyleguide/broccoli-livingstyleguide](https://github.com/livingstyleguide/broccoli-livingstyleguide#usage).


## Ember CLI

See [livingstyleguide/broccoli-livingstyleguide](https://github.com/livingstyleguide/broccoli-livingstyleguide#usage) (comments on Ember CLI can be found there).


----


## Writing the style guide

Just write normal Markdown. The style guide examples are written in code blocks surrounded by three backticks:

    ```
    <h1>This is an example</h1>
    ```

Just make sure, when you write a headline, put a space between `#` and the headline.
In other words: `# Headline`, not `#Headline`.

In addition to Markdown, there are several commands (starting with an `@`) which automate things to make generating style guides more fun. Commands can be used within and outside of code blocks, but will have a different meaning. Commands available are:

* [@import](#importing-files)
* [@colors](#colors)
* [@haml](#haml-examples)
* [@scss](#manipulating-css-per-example)
* [@javascript](#javascript-examples)
* [@coffee-script/@coffee](#coffeescript-examples)
* [@font-example](#font-examples)
* [@require](#require-ruby-files-or-gems)


## Importing Files

You can import any other *.lsg file at any place within any *.lsg file:

    ```
    // Import a file:
    @import folder/file.lsg

    // Import a file (`.lsg` will be added by default):
    @import folder/file

    // Import a file starting with `_` (folder/_file.lsg); this works automatically:
    @import folder/file

    // Import multiple files:
    @import folder/*.lsg
    @import folder/*

    // Importing from multiple folders:
    @import **/*.lsg
    @import **/*

    // Importing a Haml file (the resulting HTML will be rendered into the style guide):
    @import folder/file.haml
    @import folder/*.haml
    @import **/*.haml
    ```

All file types supported by [Tilt](https://github.com/rtomayko/tilt#readme) can be imported.
By default, `@import` is looking for `*.lsg` files.


## Writing Examples

A default example outputs the HTML source as:

* Real HTML in a wrapper to display the results
* Syntax-highligted code below

Example:

    ```
    <button class="button">Example button</button>
    ```

There are more **commands** to generate output. They start with an `@` and can be put in the code block:


### Colors

You can automatically generate color swatches out of your Sass variables:

    @colors {
      $light-red  $gray  $green  $red  $dark-red  $black
    }

By clicking the color swatch in the style guide, users can copy the hex code of
the color (useful for designers). When pointing the cursor on the variable name,
it will be copied on click instead (useful for developers).

The output will respect newlines. The example below will create a 3 × 3 matrix
of color swatches and groups shades in columns which might be more easy to
understand. `-` leaves a cell empty in the matrix:

    @colors {
      -       $light-red  $gray
      $green  $red        -
      -       $dark-red   $black
    }

The LivingStyleGuide also supports CSS colors and Sass functions. All of them
will work:

    @colors {
      red        #ca1f70              #FFF               rgba(0, 0, 0, 0.5)
      $my-color  my-color-function()  lighten(red, 10%)  darken($my-color, 20%)
    }


### Haml Examples

This will output the code as HTML but display the syntax highlighted
source as Haml ([learn how to use Haml by default](#default-commands)):

    ```
    @haml
    %button.button Example button
    ```


### Manipulating CSS per example

You can add any CSS to each example if it helps to make it better in the style guide only.
For example, add some margin between elements:

    ```
    <button class="button">Example button</button>
    <button class="button -primary">Example button</button>
    @css {
      .button + .button {
        margin-left: 3em;
      }
    }
    ```

This adds `3em` margin between both buttons.
To avoid this to affect other examples, the CSS code will be scoped to this example only (each example automatically gets a unique id).

If you need the same CSS code for several examples, you can put the CSS outside of the example.
This way it will be scoped to the current file:


    ```
    <button class="button">Example button</button>
    <button class="button -primary">Example button</button>
    ```

    ```
    <a class="button">Example button</a>
    <a class="button -primary">Example button</a>
    ```

    @css {
      .button + .button {
        margin-left: 3em;
      }
    }

For Sass you can also use `@sass` and `@scss`:

    @sass
      .button + .button
        margin-left: 3em

    @scss {
      .button + .button {
        margin-left: 3em;
      }
    }

Within the `@scss`/`@sass` helper, all variables, mixins, … of your project are
available. For example, if `my-styles.scss` sets `$my-project-margin`, you can
write this:

    @scss my-styles.scss

    @scss {
      .button + .button {
        margin-left: $my-project-margin;
      }
    }

It is possible to add Sass code without scoping (works for `@css/scss/sass`).

    @scss scope: global {
      .code { ... }
    }

Or as a shortcut inspired by Sass’ global variables (for `@scss/@sass`):

    @scss !global {
      .code { ... }
    }


### JavaScript Examples

This will show and execute the JavaScript, e. g. you designed tabs and
need few lines of jQuery to bring them alive.

    ```
    @javascript {
      $(".button").click(function() {
        alert("Hello World!");
      });
    }
    ```


### CoffeeScript Examples

Same example but using [CoffeeScript](http://coffeescript.org). It will be
executed as JavaScript and displayed as CoffeeScript:

    ```
    @coffee-script
      $(".button").click ->
        alert "Hello World!"
    ```


### Font Examples

Show which fonts should be used on your website—this will output and example text block (A—Z, a—z, 0—9, and some special characters) of the given font. It accepts valid CSS like for `font: 32px comic sans ms;`.


    @font-example 32px comic sans ms


Use your own text (defaults to “ABC…\nabc…\n123…\n!&…” if not set):

    @font-example 32px comic sans ms {
      Schweißgequält zündet Typograf Jakob
      verflixt öde Pangramme an.
    }


### Require Ruby files or Gems

You can require any Ruby file (e.g. for custom commands) or Ruby Gems (e.g. a
Compass plugin:

    Loads `my-ruby-file.rb`:
    @require my-ruby-file

    Loads the Susy Gem (must be installed on your system):
    @require susy


### Output Code

If you just want to output code with no extras (just like in a normal Markdown file), you only need to add the language:

    ``` html
    <div>Some HTML that just gets syntax-higlighted but not put into the document’s DOM</div>
    ```

No syntax highlighter:

    ``` plain
    <div>Some HTML that just gets syntax-higlighted but not put into the document’s DOM</div>
    ```


### Default Options

You can set options to apply to all commands or all commands giving a
name.
This is useful, when you depend on Haml or other templating engines.
Add a list of default commands to your _styleguide.html.lsg_:

For example without defaults:

    @header
      @haml
      .my-header My Style Guide

    ```
    @haml
    .my-example
    ```

With defaults:

    @default type: haml

    @header
      .my-header My Style Guide

    ```
    .my-example
    ```

## Working with Existing View Templates

If you want your style guide to work as an API, you might have views
already written somewhere else and don’t want to write the same HTML
code into the style guide.

First, there is the `@data` command, which sets local variables to
render the view:

    ```
    <h1><%= foo %></h1>
    @type erb
    @data {
      "foo": "bar"
    }
    ```

This will render as `<h1>bar</h1>` in the HTML but show the ERB source
below. The data is written using JSON or YAML syntax (as JSON is a subset of
YAML):

    ```
    <h1><%= foo %></h1>
    @type erb
    @data format: yaml
      foo: bar
    ```

If there is already a view template, let’s name it
`views/headline.html.erb`, you can use it:

    ```
    @use views/headline.html.erb
    @data {
      "foo": "bar"
    }
    ```

Note: You don’t need to set the `@type` as this is taken from the view
template file suffix.


### Tipp: Edge Cases

By repeating using the same template with different data, you can show
edge cases—like very long user names or missing values—in your style
guide.


## Styling the Style Guide

### Custom Header

The examples in [the screenshot above](#readme) use custom headers to have an individual look.
You can add whatever HTML you want and some Sass to style it to your _styleguide.html.lsg:_

```
@header {
  <div class="my-header">
    <img src="my-style-guide-logo.svg" alt="My Style Guide">
    <h1>My Style Guide</h1>
  </div>
}
```

You can use any templating engine supported by Tilt:

```
@header type: haml
  .my-header
    %img(src="my-style-guide-logo.svg" alt="My Style Guide")
    %h1 My Style Guide
```


### Custom Footer

See [Custom Header](#custom-header), just use `@footer`.


### Custom Head Elements

See [Custom Header](#custom-header), just use `@head`. This way you can
add any `<meta>` tag or link additional files.


### Search

Enable search for the style guide:

```
@search-box
```

This will add a search box on top of the style guide which commands the content via JavaScript.

You can also customize (e.g. translate) the placeholder for the search box:

```
@search-box placeholder: Buscar
```


### Custom Settings

Most of the design of the style guide itself, is calculated by few variables in the _styleguide.html.lsg:_

```
@style font-family: comic sans ms, arial, sans-serif
@style font-size: 7em
@style background-color: red
@style border-color: $my-color
@style color: #eee
@style code-color: darken(red, 10%)
@style color-swatch-border-radius: 0
```

* For a full list of options, [have a look at the source](https://github.com/livingstyleguide/livingstyleguide/blob/master/stylesheets/_livingstyleguide.scss) (just strip `$lsg-` from the variables).
* Every Sass expression is allowed
* Variables defined in your production Sass are available
* `code-color` generates a whole color scheme for syntax highlighting in your corporate colors
* `color-swatch-border-radius: 0` creates squared color swatches

Just play a bit and create an individual style guide which represents your personal taste :)


## Including JavaScript

If you need external JavaScript files to be included in the style guide, there are two options: before (in the `<head>`) or after (just before the closing `</body>`). It accepts a list of URLs (ending with `*.js`) or plain JavaScript code:

```
@javascript-before assets/modernizr.js

@javascript-after http://code.jquery.com/jquery-2.1.3.min.js
@javascript-after assets/application.js
@javascript-after {
  $(function() {
    // custom code
  });
}
```

If you use [@javascript](#javascript-examples) or [@coffee-script](#coffeescript-examples), your application files and jQuery might need to be included in the `javascript-before` section.


### Using CoffeeScript

Same example as above, just using CoffeeScript. Note, it is using the
indented syntax (no colon but indent following lines by two spaces)
which works well with CoffeeScript.

```
@javascript-before assets/modernizr.js

@javascript-after http://code.jquery.com/jquery-2.1.3.min.js
@javascript-after assets/application.js
@javascript-after transpiler: coffee-script
  $ ->
    # custom code
```

----


## Installation

Add this line to your application’s Gemfile:

``` ruby
gem "livingstyleguide"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install livingstyleguide


----


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Check your changes for coding style:
  * `scss-lint -c .scss-style.yml **/*.scss`
  * `rubocop --config .ruby-style.yml`
4. Commit your changes (`git commit -am "Add some feature"`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request


----


## Copyright

Copyright 2012—2016 [Nico Hagenburger](http://www.hagenburger.net).
See [MIT-LICENSE.md](MIT-LICENSE.md) for details.
Get in touch with [@hagenburger](http://twitter.com/hagenburger) on Twitter or [open an issue](https://github.com/livingstyleguide/livingstyleguide/issues/new).
