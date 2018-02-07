# LivingStyleGuide Core

A [Markdown] API built on top of [Marked].


## Usage

``` js
const Document = require('@livingstyleguide/core/document')
const source = `
# Hello World
`
const doc = new Document(source)
console.log(doc.render())
```


## Configuration

Adding a custom configuration:

``` js
const Config = require('@livingstyleguide/core/config')
const Document = require('@livingstyleguide/core/document')
const config = new Config()
const doc = new Document(source, config)
```


### Marked options

All [options to configure Marked] can be used for the configuration:

``` js
const Config = require('@livingstyleguide/core/config')
const Document = require('@livingstyleguide/core/document')
const config = new Config()
config.markedOptions.tables = false
const doc = new Document(source, config)
```


### Class names

Custom class names can be set for `h1` to `h4`, `p`, `li` as well as the `root`
(wrapper for the document).

``` js
const Config = require('@livingstyleguide/core/config')
const Document = require('@livingstyleguide/core/document')
const config = new Config()
config.classNames.h1 = 'my-headline'
const doc = new Document('# Hello world', config)
doc.render() // => '... <h1 class="my-headline">Hello ...'
```


### Info string parsers

The info string is additional infomartion added to the optening of a code block:

```` markdown
``` info string
code block
```
````

Usually this is used for defining the language of the code used for a syntax
highlighter. All information given after the language (or a file name defining
the language by its suffix) can be parsed by adding an `infoStringParser`.

The example below replaces the code block source defined in the Markdown source by new text

``` js
const Config = require('@livingstyleguide/core/config')
const Document = require('@livingstyleguide/core/document')
const config = new Config()
config.addInfoStringParser(/^!!!"([^"]+)"/, (matches) => {
  this.source = matches[1] // content of ([^"]+)
})
const doc = new Document('``` html !!!new source\nold source\n```', config)
doc.render() // => '... <code class="lang-html">new source</code> ...'
```


## Attributes

### title

After parsing the Markdown source, `title` conains the text of the first
headline (level 1).

``` js
const Document = require('@livingstyleguide/core/document')
const doc = new Document('# My document')
console.log(doc.title) // => 'My document'
```


[Markdown]: https://daringfireball.net/projects/markdown/
[Marked]: https://github.com/chjj/marked
[Options to configure Marked]: https://github.com/chjj/marked#options-1
