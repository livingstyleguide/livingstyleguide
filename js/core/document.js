const marked = require('marked')

module.exports = class Document {
  constructor (source) {
    this.source = source
    this.tokenize()
  }

  tokenize () {
    this.tokens = []

    const lexer = new marked.Lexer(this.config.markedOptions)

    lexer.lex(this.source).forEach((token) => {
      this.tokens.push(token)
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
