# Living Style Guide

Easily create living style guides by adding Markdown documentation to
your Sass.

![Build Status Images](https://travis-ci.org/hagenburger/livingstyleguide.png)

## Rails Integration

1) Create *_app/assets/stylesheets/styleguide.html.lsg_* with:
   ``` yaml
   source: application.css.scss # replace with your default Sass/SCSS file name
   title: "My Living Style Guide"
   ```

2) Write documentation for each module *app/assets/stylesheets/partials/_buttons.md* (to describe *_buttons.sass* in the same folder):
   
       Buttons
       =======

       ~~~ example
       <button class="button">Example button</button>
       ~~~ 

       ~~~ example
       <button class="button -is-primary">Example button</button>
       ~~~ 

3) Open <http://localhost:3000/assets/styleguide.html>.
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

    ~~~ example
    @javascript
    $('.button').click(function() {
      alert('Hello World!');
    });
    ~~~


### CoffeeScript example

Same example but using [CoffeeScript](http://coffeescript.org). It will be 
executed as JavaScript and displayed as CoffeeScript:

    ~~~ example
    @javascript
    $('.button').click ->
      alert 'Hello World!'
    ~~~


### Font example

Show which fonts should be used on your website—this will output and example text block (A—Z, a—z, 0—9, and some special characters) of the given font. It accepts valid CSS like for `font: 32px Comic Sans;`.

    ~~~ example
    @font-example 32px Comic Sans
    ~~~


## Installation

Add this line to your application's Gemfile:

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
