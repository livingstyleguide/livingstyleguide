const PreHighlighter = require('@lsg/prehighlighter')
const escape = require('./escape')

module.exports = class Code {
  constructor (source, lang, config) {
    this.source = source
    this.options = (lang || '').split(/ +/)
    this.lang = this.options.shift().toLowerCase()
    this.config = config
    this.parts = ['code']
    this.classList = [this.config.classNames.example]
    this.id = null
    this.preHighlighter = new PreHighlighter()
    this.parseOptions()
    let highlight = (this.lang && this.config.highlight) ? this.config.highlight : escape
    this.highlightedSource = this.preHighlighter.process(this.source, this.lang, highlight)
    this.plain = this.preHighlighter.plain(this.source)
  }

  html () {
    const templatingEngine = this.config.templatingEngines[this.lang] ||
                             this.config.templatingEngines.default
    return templatingEngine(this.plain)
  }

  render () {
    let html = `<div class="${this.classList.join(' ')}" id="${this.id}">`
    this.parts.forEach((part) => {
      html += (this.config.renderers[part] || (() => `Missing renderer \`${part}\`.`))(this)
    })
    html += '</div>'
    return html
  }

  parseOptions () {
    this.options.forEach((option) => {
      if (option.match(/^\+(.+)$/)) {
        option = option.slice(1)
        try {
          this.config.commands[option](this)
        } catch (e) {
        }
      }
      if (option.match(/^-(.+)$/)) {
        option = option.slice(1)
        let index = this.parts.indexOf(option)
        if (index) {
          this.parts.splice(index, 1)
        }
      } else if (option.match(/^\.(.+)$/)) {
        this.classList.push(option.slice(1))
      } else if (option.match(/^#(.+)$/)) {
        this.id = option.slice(1)
      }
    })
  }
}
