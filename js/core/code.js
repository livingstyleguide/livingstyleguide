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
    const match = infoString.match(/^(.+?\.)?(.+)$/)
    if (match) {
      if (match[1]) this.filename = infoString
      this.lang = match[2]
    } else {
      this.lang = infoString
    }
  }

  _parseInfoString (infoString) {
    if (!infoString) return
    const options = infoString.split(/ +/)
    if (options[0].match(/^[^#.]/)) {
      this._parseLang(options.shift())
    }
    options.forEach((option) => {
      if (option.match(/^\.(.+)$/)) {
        this.classList.push(option.slice(1))
      } else if (option.match(/^#(.+)$/)) {
        this.id = option.slice(1)
      }
    })
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
