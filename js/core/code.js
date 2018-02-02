module.exports = class Code {
  constructor (source, infoString, config) {
    this.source = source
    this.parts = ['code']
    this.config = config
    this._parseLang(infoString)
  }

  render () {
    let html = `<div>`
    this.parts.forEach((part) => {
      html += (this.config.renderers[part] || (() => `Missing renderer \`${part}\`.`))(this)
    })
    html += '</div>'
    return html
  }

  _parseLang (infoString) {
    if (!infoString) return
    const match = infoString.match(/^(.+?\.)?(.+)$/)
    if (match) {
      if (match[1]) this.filename = infoString
      this.lang = match[2]
    } else {
      this.lang = infoString
    }
  }
}
