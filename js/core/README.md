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


[Markdown]: https://daringfireball.net/projects/markdown/
[Marked]: https://github.com/chjj/marked
