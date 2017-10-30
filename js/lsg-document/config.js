const escape = require('./escape')
const fs = require('fs')
const path = require('path')

module.exports = class Config {
  constructor () {
    this.classNames = {
      root: 'lsg',
      h1: 'lsg-pagetitle',
      h2: 'lsg-headline',
      h3: 'lsg-sub-headline',
      h4: 'lsg-sub-sub-headline',
      p: 'lsg-paragraph',
      li: 'lsg-list-item',
      example: 'lsg-example',
      code: 'lsg-code',
    }
    this.commands = {}
    this.renderers = {
      code: (code) => {
        return `<pre class="${this.classNames.code} language-${code.lang || 'plain'}">` +
               `<code>${code.highlightedSource}</code>` +
               '</pre>'
      },
    }
    this.templatingEngines = {
      default: escape,
      html: (source) => source,
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
      xhtml: false,
    }
    this.contents = {}
  }

  command (name, callback) {
    this.commands[name] = callback
  }

  renderer (name, callback) {
    this.renderers[name] = callback
  }

  use (plugin) {
    plugin.call(this, this)
  }

  add (what, content) {
    this.contents[what] = this.contents[what] || []
    this.contents[what].push(content)
  }

  addFile (what, ...file) {
    this.add(what, new Promise((resolve, reject) => {
      fs.readFile(path.join(...file), (err, content) => {
        if (err) {
          return reject(err)
        }
        resolve(content.toString())
      })
    }))
  }

  get (what) {
    return Promise.all(this.contents[what] || [])
      .then((contents) => contents.map((c) => typeof c === 'function' ? c() : c).join(''))
      .catch(console.log.bind(console))
  }
}
