const marked = require('marked')

module.exports = class Document {
  constructor (source) {
    this.source = source
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
    let markedOptions = {
      renderer: renderer
    }

    let html = marked.parser(this.tokens, markedOptions)
    return `<div>\n${html}\n</div>`
  }

  render () {
    let html = this.renderContent()

    return html
  }
}
