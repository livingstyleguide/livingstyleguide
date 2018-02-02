const marked = require('marked')

module.exports = class Config {
  constructor () {
    this.classNames = {
      root: 'lsg',
      h1: 'lsg-pagetitle',
      h2: 'lsg-headline',
      h3: 'lsg-sub-headline',
      h4: 'lsg-sub-sub-headline',
      p: 'lsg-paragraph',
      li: 'lsg-list-item'
    }

    this.markedOptions = {
      gfm: true,
      tables: true,
      breaks: false,
      pedantic: false,
      sanitize: false,
      sanitizer: null,
      mangle: true,
      smartLists: false,
      silent: false,
      highlight: false,
      langPrefix: 'lang-',
      smartypants: false,
      headerPrefix: '',
      xhtml: false
    }

    this.renderers = {
      code: (code) => {
        const object = {options: this.markedOptions}
        return marked.Renderer.prototype.code.call(object, code.source, code.lang)
      }
    }
  }
}
