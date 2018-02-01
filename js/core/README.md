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
