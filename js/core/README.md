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
