const marked = require('marked')
const Config = require('./config')

module.exports = class Document {
  constructor (source, config) {
    this.source = source
    this.config = config || new Config()
    this.title = null
    this.tokenize()
  }

  tokenize () {
    this.tokens = []

    const lexer = new marked.Lexer(this.config.markedOptions)

    lexer.lex(this.source).forEach((token) => {
      if (token.type === 'heading') {
        if (!this.title && token.depth === 1) {
          this.title = token.text
        }
        this.tokens.push(token)
      } else {
        this.tokens.push(token)
      }
    })

    this.tokens.links = []
  }

  renderContent () {
    const renderer = new marked.Renderer()

    renderer.heading = (text, level, raw) => {
      const id = raw.toLowerCase().replace(/[^\w]+/g, '-')
      return (
        `<h${level} class="${this.config.classNames['h' + level]}" id="${id}">` +
        text +
        `</h${level}>\n`
      )
    }
    renderer.paragraph = (text) => {
      return `<p class="${this.config.classNames.p}">${text}</p>\n`
    }
    renderer.listitem = (text) => {
      return `<li class="${this.config.classNames.li}">${text}</li>\n`
    }

    let markedOptions = {
      renderer: renderer
    }
    Object.assign(markedOptions, this.config.markedOptions)

    let html = marked.parser(this.tokens, markedOptions)
    return `<div class="${this.config.classNames.root}">\n${html}\n</div>`
  }

  render () {
    let html = this.renderContent()

    return html
  }
}
