# Living Style Guide

Easily create living style guides by adding Markdown documentation to
your Sass.

![Build Status Images](https://travis-ci.org/hagenburger/livingstyleguide.png)


## Getting Started

* [Command Line Interface](#command-line-interface)
* [Rails Integration](#rails-integration)
* [Middleman Integration](#middleman-integration)


## Command Line Interface

1) Setup
   ```
   $ gem install livingstyleguide
   ```

2) Create *_sass/styleguide.html.lsg_* (replace `sass/` with the directory name of your Sass files) with:
   ``` yaml
   source: application.css.scss # replace with your default Sass/SCSS file name
   title: "My Living Style Guide"
   ```

3) Write documentation for each module *sass/partials/_buttons.md* (to describe *_buttons.sass* in the same folder):

       Buttons
       =======

       ~~~
       <button class="button">Example button</button>
       ~~~ 

       ~~~
       <button class="button -is-primary">Example button</button>
       ~~~ 

4) Call `livingstyleguide compile sass/styleguide.html.lsg`
   This will automatically:
   * Combine all Markdown files and convert them to HTML
   * Create a beautyful style guide
   * Saves the style guide as _styleguide.html_ in your output folder (e.g. `css/`)
   * Show the HTML source syntax highlighted close to each example


## Rails Integration

1) Setup:  
   Add this line to your application’s _Gemfile_:

   ```
    gem 'livingstyleguide'
   ```

   And then execute:

   ```
    $ bundle
    $ rails s
   ```

2) Create *_app/assets/stylesheets/styleguide.html.lsg_* with:
   ``` yaml
   source: application.css.scss # replace with your default Sass/SCSS file name
   title: "My Living Style Guide"
   ```

3) Write documentation for each module *app/assets/stylesheets/partials/_buttons.md* (to describe *_buttons.sass* in the same folder):

       Buttons
       =======

       ~~~
       <button class="button">Example button</button>
       ~~~ 

       ~~~
       <button class="button -is-primary">Example button</button>
       ~~~ 

4) Open <http://localhost:3000/assets/styleguide.html>.
   This will automatically:
   * Combine all Markdown files and convert them to HTML
   * Create a beautyful style guide
   * Show the HTML source syntax highlighted close to each example


## Middleman Integration

1) Setup:  
   Add this line to your application’s _Gemfile_:

   ```
    gem 'livingstyleguide'
   ```

   And then execute:

   ```
    $ bundle
    $ middleman
   ```

2) Create *_source/styleguide.html.lsg_* with:
   ``` yaml
   source: css/application.css.scss # replace with your default Sass/SCSS file name
   title: "My Living Style Guide"
   ```

3) Write documentation for each module *source/css/partials/_buttons.md* (to describe *_buttons.sass* in the same folder):

       Buttons
       =======

       ~~~
       <button class="button">Example button</button>
       ~~~ 

       ~~~
       <button class="button -is-primary">Example button</button>
       ~~~ 

4) Open <http://localhost:4567//styleguide.html>.
   This will automatically:
   * Combine all Markdown files and convert them to HTML
   * Create a beautyful style guide
   * Show the HTML source syntax highlighted close to each example


## More

### Haml Examples

This will output the code as HTML but display the syntax highlighted
source as Haml:

    ~~~
    @haml
    %button.button Example button
    ~~~


### JavaScript example

This will show and execute the JavaScript, e. g. you designed tabs and
need few lines of jQuery to bring them alive.

    ~~~
    @javascript
    $('.button').click(function() {
      alert('Hello World!');
    });
    ~~~


### CoffeeScript example

Same example but using [CoffeeScript](http://coffeescript.org). It will be
executed as JavaScript and displayed as CoffeeScript:

    ~~~
    @coffee-script
    $('.button').click ->
      alert 'Hello World!'
    ~~~


### Font example

Show which fonts should be used on your website—this will output and example text block (A—Z, a—z, 0—9, and some special characters) of the given font. It accepts valid CSS like for `font: 32px Comic Sans;`.

    ~~~
    @font-example 32px Comic Sans
    ~~~


## Installation

Add this line to your application’s Gemfile:

    gem 'livingstyleguide'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install livingstyleguide


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Copyright

Copyright (c) 2012 – 2014 [Nico Hagenburger](http://www.hagenburger.net).
See [MIT-LICENSE.md](MIT-LICENSE.md) for details.
Get in touch with [@hagenburger](http://twitter.com/hagenburger) on Twitter.
