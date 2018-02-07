const Config = require('./config')

module.exports = class Code {
  constructor (source, infoString, config) {
    this.source = source
    this.parts = ['code']
    this.config = config || new Config()
    this.classList = []
    this._parseInfoString(infoString)
  }

  render () {
    let html = `<div${this._renderAttributes()}>`
    this.parts.forEach((part) => {
      html += (this.config.renderers[part] || (() => `Missing renderer \`${part}\`.`))(this)
    })
    html += '</div>'
    return html
  }

  _parseLang (infoString) {
    return infoString.replace(/^([\w_-]+?\.)?(\w+)/, (filename, basename, suffix) => {
      if (basename) {
        if (basename) this.filename = infoString
        this.lang = suffix
      } else {
        this.lang = filename
      }
      return ''
    })
  }

  _parseInfoString (infoString) {
    if (!infoString) return
    infoString = this._parseLang(infoString)
    let keepGoing = true
    while (infoString.length && keepGoing) {
      keepGoing = false
      infoString = infoString.trimLeft()
      this.config.infoStringParsers.forEach((parser) => {
        infoString = infoString.replace(parser.regexp, (...matches) => {
          keepGoing = true
          parser.func.call(this, matches)
          return ''
        })
      })
    }
  }

  _renderAttributes () {
    let attributes = ''
    if (this.classList.length > 0) {
      attributes += ` class="${this.classList.sort().join(' ')}"`
    }
    if (this.id) {
      attributes += ` id="${this.id}"`
    }
    return attributes
  }
}
